import { Request, Response } from 'express';

export class SupportController {
  async createTicket(req: Request, res: Response) {
    res.status(201).json({
      status: 'success',
      message: 'Ticket created',
      data: { ticket: { id: 'ticket-id' } },
    });
  }

  async getTickets(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      data: { tickets: [] },
    });
  }
}