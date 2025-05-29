/**
 * Root module – only imports real functions.
 * Keep this file tiny so cold-start is minimal.
 */
const personalChat = require("./notifications/personalChat");
const callNotification = require("./notifications/callNotification");
const cleanFirestore = require("./maintenance/cleanFirestore");
const groupMessage = require("./notifications/group/groupMessage");
const groupJoinRequest = require("./notifications/group/groupJoinRequest");

exports.personalChat = personalChat.personalChat;
exports.sendCallNotification = callNotification.sendCallNotification;
exports.cleanFirestore = cleanFirestore.cleanFirestore;
exports.groupMessage = groupMessage.groupMessage;
exports.groupJoinRequest = groupJoinRequest.groupJoinRequest;

require("./helpers/admin");
require("./helpers/fcm");
