const express = require('express');
const { protect } = require('../middleware/auth.middleware');
const Customer = require('../models/Customer');

const router = express.Router();

// Get current customer's onboarding/KYC status
router.get('/me', protect, async (req, res, next) => {
  try {
    const customer = await Customer.findByUserId(req.user.id);
    res.json({ success: true, customer });
  } catch (err) {
    next(err);
  }
});

// Submit KYC/onboarding details (simple text fields)
router.post('/me/kyc', protect, async (req, res, next) => {
  try {
    const { fullName, panId, address } = req.body;
    const customer = await Customer.upsertKyc(req.user.id, { fullName, panId, address });
    res.json({ success: true, customer });
  } catch (err) {
    next(err);
  }
});

module.exports = router;

