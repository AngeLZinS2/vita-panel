-- Seed script for the application
-- PURPOSE: after the schema is created, run this script to add an admin user profile/roles
-- and some example data so the frontend can be tested.

-- IMPORTANT: This script does NOT create the Auth user (the row in auth.users).
-- You MUST create the Auth user first (see instructions below) and then replace
-- the placeholder <ADMIN_UUID> with the actual UUID of that Auth user.

-- Recommended: create the Auth user in the Supabase Dashboard (Authentication -> Users -> New user)
-- or use the Admin API (example cURL shown below). After creation you'll receive the user's `id` (UUID).

-- Example Admin API (replace SERVICE_ROLE_KEY and PROJECT_URL):
-- curl -X POST "https://<PROJECT_REF>.supabase.co/auth/v1/admin/users" \
--  -H "apikey: <SERVICE_ROLE_KEY>" \
--  -H "Authorization: Bearer <SERVICE_ROLE_KEY>" \
--  -H "Content-Type: application/json" \
--  -d '{"email":"admin@gmail.com","password":"teste123","email_confirm":true}'

-- After you get the user id (UUID), open this file and replace <ADMIN_UUID> everywhere
-- then run this SQL in the SQL editor of your Supabase project (or with psql/supabase CLI).

BEGIN;

-- Replace the string <ADMIN_UUID> below with the actual UUID from the Auth user
-- Example: '2f1b5f9a-...'
-- ADMIN USER PROFILE & ROLE
INSERT INTO public.profiles (id, name, cpf, phone, avatar)
VALUES ('17514ac3-a390-438e-80e1-7eb462cc5505', 'Admin User', NULL, '+5511999999999', NULL)
ON CONFLICT (id) DO UPDATE
  SET name = EXCLUDED.name,
      cpf = EXCLUDED.cpf,
      phone = EXCLUDED.phone;

INSERT INTO public.user_roles (id, user_id, role)
SELECT gen_random_uuid(), '17514ac3-a390-438e-80e1-7eb462cc5505', 'admin'
WHERE NOT EXISTS (
  SELECT 1 FROM public.user_roles WHERE user_id = '17514ac3-a390-438e-80e1-7eb462cc5505' AND role = 'admin'
);

-- Make the admin a staff member too (optional; useful if frontend expects staff rows)
INSERT INTO public.staff (id, user_id, specialty, registration_number, status)
SELECT gen_random_uuid(), '17514ac3-a390-438e-80e1-7eb462cc5505', 'Administrator', 'ADM-0001', 'active'
WHERE NOT EXISTS (
  SELECT 1 FROM public.staff WHERE user_id = '17514ac3-a390-438e-80e1-7eb462cc5505'
);

-- Create a sample patient (profile) to use in demo appointments/medical_records
DO $$
DECLARE
  patient_id uuid := gen_random_uuid();
BEGIN
  INSERT INTO public.profiles (id, name, cpf, phone, avatar)
  VALUES (patient_id, 'Paciente Exemplo', NULL, '+5511988887777', NULL);

  -- create a patient user role
  INSERT INTO public.user_roles (id, user_id, role)
  VALUES (gen_random_uuid(), patient_id, 'patient');

  -- create a sample appointment between the patient and the admin staff
  INSERT INTO public.appointments (id, patient_id, doctor_id, appointment_date, status, reason, notes)
  VALUES (gen_random_uuid(), patient_id, (SELECT user_id FROM public.staff WHERE user_id = '17514ac3-a390-438e-80e1-7eb462cc5505' LIMIT 1), now() + interval '7 days', 'scheduled', 'Consulta de rotina', 'Agendada via seed script');

  -- create a sample medical record for that appointment
  INSERT INTO public.medical_records (id, patient_id, doctor_id, appointment_id, diagnosis, prescription, notes)
  VALUES (gen_random_uuid(), patient_id, (SELECT user_id FROM public.staff WHERE user_id = '17514ac3-a390-438e-80e1-7eb462cc5505' LIMIT 1), (SELECT id FROM public.appointments WHERE patient_id = patient_id LIMIT 1), 'Nenhuma anomalia', 'Paracetamol 500mg', 'Registro criado pelo seed');
END;
$$;

-- Sample inventory items
INSERT INTO public.inventory (id, name, description, quantity, unit, minimum_quantity, category)
VALUES
  (gen_random_uuid(), 'Syringe 10ml', 'Seringa descartável 10ml', 200, 'unit', 10, 'supply'),
  (gen_random_uuid(), 'Estetoscópio', 'Estetoscópio padrão', 10, 'unit', 1, 'equipment'),
  (gen_random_uuid(), 'Paracetamol 500mg', 'Embalagem com 20 comprimidos', 50, 'box', 5, 'medication')
ON CONFLICT (id) DO NOTHING;

COMMIT;

-- End of seed script
