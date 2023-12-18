const router = require('express').Router();
const apiController = require('../controllers/api_controller');
const passport = require('passport')


router.get('/', (req, res) => { res.json("ok") });
router.get('/scrapLink', apiController.scrapLink);
router.post('/signUp', apiController.signUp);
router.post('/signIn', apiController.signIn);
router.get('/users', apiController.users);
router.get('/signUp', apiController.signUpDeneme)
router.get('/signIn', apiController.signInDeneme)

router.get('/api/google', passport.authenticate('google', {
    scope: ['profile', 'email']
}))
router.get('/auth/google/callback', passport.authenticate('google', {
    failureRedirect: '/auth/error',
}), (req, res) => {
    res.redirect('/api/signinwithgoogle')
})
router.get('/api/signinwithgoogle', apiController.signinwithgoogle)


module.exports = router;