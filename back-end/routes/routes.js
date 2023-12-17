const router = require('express').Router();
const apiController = require('../controllers/api_controller');


router.get('/', (req, res) => { res.json("ok") });
router.get('/scrapLink', apiController.scrapLink);
router.post('/signUp', apiController.signUp);
router.post('/signIn', apiController.signIn);
router.get('/users', apiController.users);


module.exports = router;