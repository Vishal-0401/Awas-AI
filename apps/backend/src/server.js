require('dotenv').config();
const app = require('./app');
const User = require('./models/User');
const Customer = require('./models/Customer');
const Loan = require('./models/Loan');
const Repayment = require('./models/Repayment');

const PORT = process.env.PORT || 5000;

const startServer = async () => {
    try {
        // Initialize Database Tables
        await User.createTable();
        await Customer.createTable();
        await Loan.createTable();
        await Repayment.createTable();
        console.log('Database tables verified/created');

        app.listen(PORT, () => {
            console.log(`Server is running on port ${PORT}`);
        });
    } catch (error) {
        console.error('Failed to start server:', error);
        process.exit(1);
    }
};

startServer();

