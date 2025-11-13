-- 1. Fix handle_new_user trigger to NOT auto-assign patient role
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, name, cpf, phone)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', ''),
    COALESCE(NEW.raw_user_meta_data->>'cpf', ''),
    COALESCE(NEW.raw_user_meta_data->>'phone', '')
  );
  
  RETURN NEW;
END;
$$;

-- 2. Remove patient role from Dr. Davi if it exists
-- First find the user by email and remove the patient role
DELETE FROM public.user_roles 
WHERE user_id = (
  SELECT id FROM auth.users 
  WHERE email = 'daviribeiro@gmail.com' 
  OR email = 'davi@exemplo.com'
)
AND role = 'patient';

-- 3. Ensure doctor role exists for Dr. Davi
INSERT INTO public.user_roles (user_id, role)
SELECT u.id, 'doctor'
FROM auth.users u
WHERE (u.email = 'daviribeiro@gmail.com' OR u.email = 'davi@exemplo.com')
AND NOT EXISTS (
  SELECT 1 FROM public.user_roles ur
  WHERE ur.user_id = u.id AND ur.role = 'doctor'
);
