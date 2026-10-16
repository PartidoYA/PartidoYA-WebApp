import { writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const outputPath = fileURLToPath(new URL('../src/environments/environment.prod.ts', import.meta.url));
const apiUrl = (process.env.API_URL || 'https://partidoya-production.up.railway.app/api/v1').replace(/\/$/, '');
const googleMapsApiKey = process.env.GOOGLE_MAPS_API_KEY || '';

const source = `export const environment = {
  production: true,
  apiUrl: ${JSON.stringify(apiUrl)},
  googleMapsApiKey: ${JSON.stringify(googleMapsApiKey)}
};
`;

writeFileSync(outputPath, source, 'utf8');
