CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
  patient_id uuid;
BEGIN
  INSERT INTO auth.users (
    id, aud, role, email, encrypted_password, email_confirmed_at,
    raw_user_meta_data, created_at, updated_at, is_sso_user, is_anonymous
  )
  VALUES (
    gen_random_uuid(), 'authenticated', 'authenticated',
    'patient@example.com', crypt('patient123', gen_salt('bf')), now(),
    '{"name":"Paciente Exemplo"}'::jsonb, now(), now(), false, false
  )
  RETURNING id INTO patient_id;
  
  RAISE NOTICE 'Paciente criado: %', patient_id;
END;
$$;

SELECT id, email FROM auth.users WHERE email = 'patient@example.com' ORDER BY created_at DESC LIMIT 1;

