import { createReadStream, createWriteStream, existsSync, statSync, unlinkSync, writeFileSync } from 'node:fs';
import { createBrotliCompress, constants as zlibConstants } from 'node:zlib';
import { pipeline } from 'node:stream/promises';
import path from 'node:path';

const WEB_DIR = path.resolve(import.meta.dirname, '..', 'builds', 'Web');
const ASSETSIGNORE_PATH = path.join(WEB_DIR, '.assetsignore');
const CLOUDFLARE_MAX_ASSET_SIZE = 25 * 1024 * 1024;
// Compress before hitting the limit exactly, so a small rebuild doesn't flip a file
// back and forth between "compressed" and "plain" from one export to the next.
const COMPRESS_THRESHOLD = 20 * 1024 * 1024;

// Godot's web export always uses the export path's base name ("index"), so these are
// the only two files that can plausibly grow past the Cloudflare per-file limit.
const CANDIDATES = ['index.wasm', 'index.pck'];

const fmt = (bytes) => (bytes / (1024 * 1024)).toFixed(2) + ' MB';

let anyMissing = false;
const ignoreLines = ['*.import'];
let hadError = false;

for (const name of CANDIDATES) {
  const filePath = path.join(WEB_DIR, name);
  const brPath = `${filePath}.br`;

  if (!existsSync(filePath)) {
    anyMissing = true;
    continue;
  }

  const originalSize = statSync(filePath).size;

  if (originalSize <= COMPRESS_THRESHOLD) {
    console.log(`${name}: ${fmt(originalSize)} (abaixo do limite, servido sem compressão)`);
    if (existsSync(brPath)) {
      unlinkSync(brPath);
    }
    continue;
  }

  await pipeline(
    createReadStream(filePath),
    createBrotliCompress({
      params: {
        [zlibConstants.BROTLI_PARAM_QUALITY]: 9,
        [zlibConstants.BROTLI_PARAM_SIZE_HINT]: originalSize,
      },
    }),
    createWriteStream(brPath),
  );

  const compressedSize = statSync(brPath).size;
  const reduction = ((1 - compressedSize / originalSize) * 100).toFixed(0);
  console.log(`${name}: ${fmt(originalSize)} -> ${name}.br: ${fmt(compressedSize)} (${reduction}% menor)`);

  ignoreLines.push(name);

  if (compressedSize > CLOUDFLARE_MAX_ASSET_SIZE) {
    console.error(
      `\n${name}.br (${fmt(compressedSize)}) ainda passa do limite de 25 MiB do Cloudflare Workers.`,
    );
    console.error(
      name.endsWith('.wasm')
        ? 'Será necessário compilar templates de export customizados com módulos desabilitados.'
        : 'O .pck já é majoritariamente dados comprimidos (PNG/OGG); brotli não vai ganhar muito mais aqui. Será necessário dividir o arquivo em partes.',
    );
    hadError = true;
  } else {
    const headroom = ((1 - compressedSize / CLOUDFLARE_MAX_ASSET_SIZE) * 100).toFixed(0);
    if (compressedSize > CLOUDFLARE_MAX_ASSET_SIZE * 0.85) {
      console.warn(`  aviso: margem apertada (${headroom}% de folga até o limite de 25 MiB).`);
    }
  }
}

if (anyMissing) {
  console.error(`Nenhum arquivo de export encontrado em ${WEB_DIR}.`);
  console.error('Exporte o projeto Web pelo Godot antes de rodar este script.');
  process.exit(1);
}

writeFileSync(ASSETSIGNORE_PATH, `${ignoreLines.join('\n')}\n`);
console.log(`.assetsignore escrito em ${ASSETSIGNORE_PATH}`);

if (hadError) {
  process.exit(1);
}
