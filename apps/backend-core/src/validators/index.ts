import { z } from 'zod';

// Auth Validators
export const googleLoginSchema = z.object({
  idToken: z.string().min(1, 'idToken is required'),
});

export const sendOtpSchema = z.object({
  phone: z.string().min(10, 'Valid phone number is required'),
});

export const verifyOtpSchema = z.object({
  phone: z.string().min(10, 'Valid phone number is required'),
  otp: z.string().length(6, 'OTP must be 6 digits'),
});

export const refreshTokenSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required'),
});

// Profile Validators
export const updateProfileSchema = z.object({
  fullName: z.string().optional(),
  avatar: z.string().optional(),
  phone: z.string().optional(),
});

export const addressSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  address: z.string().min(1, 'Address is required'),
  city: z.string().min(1, 'City is required'),
  state: z.string().min(1, 'State is required'),
  zipCode: z.string().min(1, 'Zip code is required'),
  latitude: z.number().optional(),
  longitude: z.number().optional(),
  isDefault: z.boolean().optional(),
});

// Booking Validators
export const createBookingSchema = z.object({
  serviceId: z.string().uuid('Invalid service ID'),
  addressId: z.string().uuid('Invalid address ID'),
  scheduledFor: z.string().datetime({ offset: true }),
  notes: z.string().optional(),
});

// Notification Validators
export const markReadSchema = z.object({
  notificationIds: z.array(z.string()).min(1, 'Array of notification IDs is required'),
});

// AI Validators
export const scanSchema = z.object({
  imageUrl: z.string().url('A valid image URL is required'),
});

// Tracking Validators
export const updateLocationSchema = z.object({
  latitude: z.number(),
  longitude: z.number(),
  heading: z.number().optional(),
});
