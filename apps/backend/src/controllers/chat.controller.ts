import { Request, Response } from 'express';
import { chatRepository } from '../repositories/store';
import { emitToBooking } from '../services/socketHub';
import { created, ok } from '../utils/response';

export class ChatController {
  list = async (req: Request, res: Response): Promise<void> => {
    ok(res, chatRepository.list(req.params.conversationId as string));
  };

  send = async (req: Request, res: Response): Promise<void> => {
    const conversationId = req.params.conversationId as string;
    const message = chatRepository.create(conversationId, req.user!.id, req.body.body as string);
    emitToBooking(conversationId, 'chat:message:new', message);
    created(res, message, 'Message sent');
  };
}
