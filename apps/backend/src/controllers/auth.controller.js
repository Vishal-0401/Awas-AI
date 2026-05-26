const User = require('../models/User');
const { hashPassword, comparePassword } = require('../utils/bcrypt');
const { generateToken } = require('../utils/jwt');

const register = async (req, res) => {
    try {
        const { name, email, password, mobile, defaultRole, isActive } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({ success: false, message: 'Please provide name, email, and password' });
        }

        const existingUser = await User.findByEmail(email);
        if (existingUser) {
            return res.status(400).json({ success: false, message: 'Email already registered' });
        }

        const hashedPassword = await hashPassword(password);

        const userId = await User.create({
            name,
            email,
            password: hashedPassword,
            mobile,
            defaultRole,
            isActive
        });

        // Onboard customer automatically at register-time
        // (create customer row with pending KYC)
        const Customer = require('../models/Customer');
        await Customer.createForUser(userId);

        // Keep `role` claim for compatibility with existing JWT middleware / role checks
        const tokenRole = defaultRole || 'customer';
        const token = generateToken({ id: userId, role: tokenRole });


        res.status(201).json({
            success: true,
            message: 'User registered successfully',
            token,
            user: { id: userId, name, email, mobile: mobile || null, role: tokenRole }
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ success: false, message: 'Server error during registration' });
    }
};


const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ success: false, message: 'Please provide email and password' });
        }

        const user = await User.findByEmail(email);
        if (!user) {
            return res.status(401).json({ success: false, message: 'Invalid credentials' });
        }

        const isMatch = await comparePassword(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ success: false, message: 'Invalid credentials' });
        }

        const tokenRole = user.defaultRole || 'customer';
        const token = generateToken({ id: user.id, role: tokenRole });

        res.status(200).json({
            success: true,
            message: 'Logged in successfully',
            token,
            user: { id: user.id, name: user.name, email: user.email, mobile: user.mobile || null, role: tokenRole }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ success: false, message: 'Server error during login' });
    }
};

module.exports = { register, login };
