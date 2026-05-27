import { z } from 'zod';

export const sendOtpSchema = z
  .object({
    phone: z.string().min(6).optional(),
    email: z.string().email().optional(),
    purpose: z.enum(['LOGIN', 'WITHDRAWAL']).default('LOGIN'),
    deviceId: z.string().optional()
  })
  .refine((value) => Boolean(value.phone || value.email), 'phone or email is required');

export const verifyOtpSchema = z
  .object({
    otpSessionId: z.string().optional(),
    phone: z.string().optional(),
    email: z.string().email().optional(),
    otp: z.string().length(6),
    purpose: z.enum(['LOGIN', 'WITHDRAWAL']).default('LOGIN')
  })
  .refine((value) => Boolean(value.otpSessionId || value.phone || value.email), 'otpSessionId, phone, or email is required');

export const googleLoginSchema = z.object({
  idToken: z.string().min(8)
});

export const refreshSchema = z.object({
  refreshToken: z.string().min(10)
});

export const profileSchema = z.object({
  fullName: z.string().min(2).optional(),
  email: z.string().email().optional(),
  phone: z.string().min(6).optional(),
  avatar: z.string().url().optional(),
  address: z.string().min(3).optional(),
  isProfileComplete: z.boolean().optional()
});

export const completeProfileSchema = z.object({
  fullName: z.string().min(2),
  address: z.string().min(3),
  email: z.string().email().optional(),
  avatar: z.string().url().optional()
});

export const addressSchema = z.object({
  title: z.string().min(1),
  address: z.string().min(3),
  city: z.string().default(''),
  state: z.string().default(''),
  zipCode: z.string().default(''),
  latitude: z.number(),
  longitude: z.number(),
  isDefault: z.boolean().default(false)
});

export const nearbyQuerySchema = z.object({
  lat: z.coerce.number(),
  lng: z.coerce.number(),
  serviceId: z.string().optional(),
  radius: z.coerce.number().optional()
});

export const servicesQuerySchema = z.object({
  categoryId: z.string().optional(),
  q: z.string().optional()
});

export const createBookingSchema = z.object({
  serviceId: z.string().min(1),
  addressId: z.string().min(1),
  workerId: z.string().optional(),
  scheduledFor: z.string().datetime().optional(),
  priority: z.enum(['normal', 'urgent', 'emergency']).default('normal'),
  diagnosticId: z.string().optional(),
  notes: z.string().optional()
});

export const bookingListQuerySchema = z.object({
  status: z.enum(['active', 'history']).optional()
});

export const cancelBookingSchema = z.object({
  reason: z.string().min(2).default('Customer cancelled')
});

export const topUpSchema = z.object({
  amount: z.number().positive()
});

export const chatMessageSchema = z.object({
  body: z.string().min(1).max(2000)
});

export const trackingUpdateSchema = z.object({
  latitude: z.number(),
  longitude: z.number(),
  heading: z.number().optional(),
  speed: z.number().optional()
});
