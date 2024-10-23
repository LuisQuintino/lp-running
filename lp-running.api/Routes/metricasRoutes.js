
const express = require('express');
const router = express.Router();
const metricasServiceController = require('../Controller/metricasServiceController');

router.post('/', metricasServiceController.createMetrica);


router.put('/:id', metricasServiceController.updateMetrica);


router.delete('/:id', metricasServiceController.deleteMetrica);


router.get('/', metricasServiceController.getMetricas);

module.exports = router;
