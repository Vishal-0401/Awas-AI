import { z } from 'zod';

export const registerSchema = z.object({
  email: z.string().email(),
  phone: z.string().min(10),
  name: z.string().min(2),
  password: z.string().min(6),
  role: z.enum(['CUSTOMER', 'WORKER', 'ADMIN']).optional(),
});

export const loginSchema = z.object({
  emailOrPhone: z.string(),
  password: z.string(),
});

export const createBookingSchema = z.object({
  serviceType: z.string(),
  scheduledDate: z.string().datetime(),
  address: z.string(),
  notes: z.string().optional(),
});

export const updateWorkerSchema = z.object({
  skills: z.string().optional(),
  availability: z.boolean().optional(),
  latitude: z.number().optional(),
  longitude: z.number().optional(),
});