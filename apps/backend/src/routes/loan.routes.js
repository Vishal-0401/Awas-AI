const express = require('express');
const { protect } = require('../middleware/auth.middleware');
const Customer = require('../models/Customer');
const Loan = require('../models/Loan');

const router = express.Router();

function calcMonthlyEmi({ principal, tenureMonths, annualRate }) {
  const r = Number(annualRate) / 12 / 100;
  const n = Number(tenureMonths);
  if (!n || n <= 0) throw new Error('Invalid tenureMonths');
  if (!r || r === 0) {
    return principal / n;
  }
  const emi = (principal * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
  return emi;
}

router.get('/', protect, async (req, res, next) => {
  try {
    const customer = await Customer.findByUserId(req.user.id);
    if (!customer) return res.status(404).json({ success: false, message: 'Customer not found' });
    const loans = await Loan.findByCustomerId(customer.id);
    res.json({ success: true, loans });
  } catch (err) {
    next(err);
  }
});

router.post('/', protect, async (req, res, next) => {
  try {
    const { amount, tenureMonths, interestRate, monthlyEmi } = req.body;

    if (!amount || !tenureMonths || !interestRate || !monthlyEmi) {
      return res.status(400).json({ success: false, message: 'amount, tenureMonths, interestRate, monthlyEmi are required' });
    }

    const customer = await Customer.findByUserId(req.user.id);
    if (!customer) return res.status(404).json({ success: false, message: 'Customer not found' });

    if (customer.kycStatus !== 'APPROVED') {
      return res.status(400).json({ success: false, message: 'KYC not completed' });
    }

    const emi = Number(monthlyEmi);
    if (!Number.isFinite(emi) || emi <= 0) return res.status(400).json({ success: false, message: 'Invalid monthlyEmi' });

    const loanId = await Loan.create({
      customerId: customer.id,
      amount: Number(amount),
      tenureMonths: Number(tenureMonths),
      interestRate: Number(interestRate),
      monthlyEmi: emi,
    });

    res.status(201).json({ success: true, loanId });
  } catch (err) {
    next(err);
  }
});

module.exports = router;

