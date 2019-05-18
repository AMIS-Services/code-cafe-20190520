'use strict';

module.exports = (sequelize, type) => {
  return sequelize.define('Customer', {
      id: {
        type: type.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      name: type.STRING,
      email: type.STRING,
      createdAt: {
        type: type.DATE,
        field: 'date_created',
        defaultValue: sequelize.literal('NOW()')
      },
      updatedAt: {
        type: type.DATE,
        field: 'date_updated'
      }
  })
}