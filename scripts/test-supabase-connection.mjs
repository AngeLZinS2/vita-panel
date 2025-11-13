import fs from 'fs';
import { createClient } from '@supabase/supabase-js';

// Simple .env loader (works without adding dotenv to dependencies)
const envPath = new URL('../.env', import.meta.url);
let envText = '';
try {
  envText = fs.readFileSync(envPath, 'utf8');
} catch (e) {
  console.error('.env file not found at', envPath.href);
  process.exit(1);
}
for (const line of envText.split(/\r?\n/)) {
  const m = line.match(/^\s*([^#=]+?)\s*=\s*(.*)\s*$/);
  if (!m) continue;
  let [, key, val] = m;
  key = key.trim();
  val = val.trim();
  if (val.startsWith('"') && val.endsWith('"')) val = val.slice(1, -1);
  process.env[key] = val;
}

const url = process.env.VITE_SUPABASE_URL;
const key = process.env.VITE_SUPABASE_ANON_KEY ?? process.env.VITE_SUPABASE_PUBLISHABLE_KEY;
if (!url || !key) {
  console.error('Missing SUPABASE env vars. Please set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY in .env');
  process.exit(2);
}

const supabase = createClient(url, key);

const tablesToTry = ['staff', 'appointments', 'inventory', 'patients'];

(async () => {
  console.log('Connecting to', url);
  for (const table of tablesToTry) {
    try {
      const { data, error } = await supabase.from(table).select('*').limit(1);
      if (error) {
        console.log(`Table ${table}: ERROR - ${error.message}`);
      } else {
        console.log(`Table ${table}: OK - returned ${Array.isArray(data) ? data.length : 0} rows`);
      }
    } catch (e) {
      console.log(`Table ${table}: Unexpected error -`, e?.message ?? e);
    }
  }
  process.exit(0);
})();
