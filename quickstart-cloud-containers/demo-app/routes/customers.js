const express = require("express");
const router = express.Router();
// dependencies
const { Customer } = require("../models");

/* GET home page. */
router.get("/", function(req, res, next) {
    Customer.findAll()
        .then(customers => {
            res.render("customers", {
                page_title: "Customers - Node.js",
                data: customers
            });
        })
        .catch(err => {
            req.flash("error", err);
            res.render("customers", {
                page_title: "Customers - Node.js",
                data: ""
            });
        });
});

// SHOW ADD USER FORM
router.get("/add", function(req, res, next) {
    // render to views/user/add.ejs
    res.render("customers/add", {
        title: "Add New Customers",
        name: "",
        email: ""
    });
});

// ADD NEW USER POST ACTION
router.post("/add", function(req, res, next) {
    req.assert("name", "Name is required").notEmpty(); //Validate name
    req.assert("email", "A valid email is required").isEmail(); //Validate email

    const errors = req.validationErrors();

    if (!errors) {
        //No errors were found.  Passed Validation!

        const user = {
            name: req
                .sanitize("name")
                .escape()
                .trim(),
            email: req
                .sanitize("email")
                .escape()
                .trim()
        };

        Customer.create({
            name: user.name,
            email: user.email,
            createdAt: new Date(),
            updatedAt: new Date()
        })
            .then(() => {
                console.log("OK");
                req.flash("success", "Customer added successfully!");
                res.redirect("/customers");
            })
            .catch(err => {
                console.log(`ERROR: ${err}`);
                req.flash("error", err);

                // render to views/user/add.ejs
                res.render("customers/add", {
                    title: "Add New Customer",
                    name: user.name,
                    email: user.email
                });
            });
    } else {
        //Display errors to user
        let error_msg = "";
        errors.forEach(function(error) {
            error_msg += error.msg + "<br>";
        });
        req.flash("error", error_msg);

        /**
         * Using req.body.name
         * because req.param('name') is deprecated
         */
        res.render("customers/add", {
            title: "Add New Customer",
            name: req.body.name,
            email: req.body.email
        });
    }
});

// SHOW EDIT USER FORM
router.get("/edit/(:id)", function(req, res, next) {

    Customer.findByPk(req.params.id)
        .then((customer) => {
            // if customer not found
            if (!customer) {
                req.flash(
                    "error",
                    "Customers not found with id = " + req.params.id
                );
                res.redirect("/customers");
            } else {
                // if user found
                // render to views/user/edit.ejs template file
                res.render("customers/edit", {
                    title: "Edit Customer",
                    id: customer.id,
                    name: customer.name,
                    email: customer.email
                });
            }
        })
        .catch(err => {
            throw err
        });
});

// EDIT USER POST ACTION
router.post("/update/:id", function(req, res, next) {
    req.assert("name", "Name is required").notEmpty(); //Validate name           //Validate age
    req.assert("email", "A valid email is required").isEmail(); //Validate email

    const errors = req.validationErrors();

    if (!errors) {
        const user = {
            name: req
                .sanitize("name")
                .escape()
                .trim(),
            email: req
                .sanitize("email")
                .escape()
                .trim()
        };

        Customer.update({
            'name': user.name,
            'email': user.email
        }, {
            where: { 'id': req.params.id }
        })
        .then(() => {
            req.flash("success", "Data updated successfully!");
            res.redirect("/customers");
        })
        .catch(err => {
            req.flash("error", err);

            // render to views/user/add.ejs
            res.render("customers/edit", {
                title: "Edit Customer",
                id: req.params.id,
                name: req.body.name,
                email: req.body.email
            });
        });
    } else {
        //Display errors to user
        let error_msg = "";
        errors.forEach(function(error) {
            error_msg += error.msg + "<br>";
        });
        req.flash("error", error_msg);

        /**
         * Using req.body.name
         * because req.param('name') is deprecated
         */
        res.render("customers/edit", {
            title: "Edit Customer",
            id: req.params.id,
            name: req.body.name,
            email: req.body.email
        });
    }
});

// DELETE USER
router.get("/delete/(:id)", function(req, res, next) {
    const user = { id: req.params.id };

    Customer.destroy({
        where: {
            id: user.id
        }
    })
        .then(() => {
            req.flash(
                "success",
                "Customer deleted successfully! id = " + req.params.id
            );
            // redirect to users list page
            res.redirect("/customers");
        })
        .catch(err => {
            req.flash("error", err);
            // redirect to users list page
            res.redirect("/customers");
        });
});

module.exports = router;
