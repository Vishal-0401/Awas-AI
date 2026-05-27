import { Request, Response } from 'express';
import { profileService } from '../services/profile.service';
import { created, ok } from '../utils/response';

export class UserController {
  me = async (req: Request, res: Response): Promise<void> => {
    ok(res, profileService.me(req.user!.id));
  };

  updateMe = async (req: Request, res: Response): Promise<void> => {
    ok(res, profileService.update(req.user!.id, req.body), 'Profile updated');
  };

  completeProfile = async (req: Request, res: Response): Promise<void> => {
    ok(res, profileService.completeProfile(req.user!.id, req.body), 'Profile completed');
  };

  listAddresses = async (req: Request, res: Response): Promise<void> => {
    ok(res, profileService.listAddresses(req.user!.id));
  };

  createAddress = async (req: Request, res: Response): Promise<void> => {
    created(res, profileService.createAddress(req.user!.id, req.body), 'Address created');
  };

  deleteAddress = async (req: Request, res: Response): Promise<void> => {
    profileService.deleteAddress(req.user!.id, req.params.id as string);
    ok(res, { deleted: true }, 'Address deleted');
  };
}
