const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
dotenv.config();

function authenticateJWT(req, res, next) {
    const token = req.header("Authorization");

    if (!token) {
        return res
            .status(401)
            .json({ message: "Unauthorized - Missing JWT token" });
    }

    jwt.verify(token, process.env.JWT_SECRET_KEY, (err, user) => {
        if (err) {
            return res
                .status(403)
                .json({ message: "Forbidden - Invalid JWT token" });
        }

        req.user = user;
        next();
    });
}

module.exports = authenticateJWT;
