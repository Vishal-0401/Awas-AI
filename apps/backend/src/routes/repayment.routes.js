const express = require('express');
const { protect } = require('../middleware/auth.middleware');
const Customer = require('../models/Customer');
const Loan = require('../models/Loan');
const Repayment = require('../models/Repayment');

const router = express.Router();

router.get('/', protect, async (req, res, next) => {
  try {
    const customer = await Customer.findByUserId(req.user.id);
    if (!customer) return res.status(404).json({ success: false, message: 'Customer not found' });
    const repayments = await Repayment.findByCustomerId(customer.id);
    res.json({ success: true, repayments });
  } catch (err) {
    next(err);
  }
});

router.post('/', protect, async (req, res, next) => {
  try {
    const { loanId, amount } = req.body;
    if (!loanId || !amount) {
      return res.status(400).json({ success: false, message: 'loanId and amount are required' });
    }

    const customer = await Customer.findByUserId(req.user.id);
    if (!customer) return res.status(404).json({ success: false, message: 'Customer not found' });

    const loan = await Loan.findByIdAndCustomerId(Number(loanId), customer.id);
    if (!loan) return res.status(404).json({ success: false, message: 'Loan not found' });

    const repayAmount = Number(amount);
    if (!Number.isFinite(repayAmount) || repayAmount <= 0) {
      return res.status(400).json({ success: false, message: 'Invalid amount' });
    }

    const repaymentId = await Repayment.create({
      loanId: loan.id,
      customerId: customer.id,
      amount: repayAmount,
    });

    await Loan.applyRepayment(loan.id, customer.id, repayAmount);

    res.status(201).json({ success: true, repaymentId });
  } catch (err) {
    next(err);
  }
});

module.exports = router;

