const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth.routes');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', authRoutes);

const customerRoutes = require('./routes/customer.routes');
const loanRoutes = require('./routes/loan.routes');
const repaymentRoutes = require('./routes/repayment.routes');
const invoiceRoutes = require('./routes/invoice.routes');

app.use('/api/customers', customerRoutes);
app.use('/api/loans', loanRoutes);
app.use('/api/repayments', repaymentRoutes);
app.use('/api/invoices', invoiceRoutes);

// Basic health check route
app.get('/', (req, res) => {
    res.send('Fintech API is running...');
});

module.exports = app;
