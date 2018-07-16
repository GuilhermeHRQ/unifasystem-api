'use strict';

const express = require('express');
const router = express.Router();

router.get('/', (req, res, next) => {
    res.status(200).json({
        content: new Date().toISOString(),
        message: 'OK'
    });
});

module.exports = router;