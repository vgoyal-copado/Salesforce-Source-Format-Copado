/**
 * @description Trigger to send welcome email when contact becomes VIP
 * @author Demo User
 * @date 2025-12-12
 */
trigger ContactVIPWelcomeTrigger on Contact (after update) {
    
    // List to hold emails to be sent
    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
    
    // Iterate through updated contacts
    for (Contact updatedContact : Trigger.new) {
        
        // Get the old version of the contact
        Contact oldContact = Trigger.oldMap.get(updatedContact.Id);
        
        // Check if VIP status changed from false to true
        Boolean becameVIP = updatedContact.VIP_Status__c == true && 
                           oldContact.VIP_Status__c == false;
        
        // Check if contact has an email address
        Boolean hasEmail = String.isNotBlank(updatedContact.Email);
        
        // If contact became VIP and has email, prepare welcome message
        if (becameVIP && hasEmail) {
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            // Set recipient
            email.setToAddresses(new String[] { updatedContact.Email });
            
            // Set email subject
            email.setSubject('Welcome to Our VIP Program!');
            
            // Build personalized email body
            String emailBody = 'Dear ' + (String.isNotBlank(updatedContact.FirstName) ? updatedContact.FirstName : 'Valued Customer') + ',\n\n';
            emailBody += 'Congratulations! You have been added to our exclusive VIP program.\n\n';
            emailBody += 'As a VIP member, you will receive:\n';
            emailBody += '- Priority customer support\n';
            emailBody += '- Exclusive offers and promotions\n';
            emailBody += '- Early access to new products\n\n';
            emailBody += 'Thank you for your continued partnership.\n\n';
            emailBody += 'Best regards,\n';
            emailBody += 'The VIP Services Team';
            
            email.setPlainTextBody(emailBody);
            
            // Add to list of emails to send
            emailsToSend.add(email);
        }
    }
    
    // Send all emails (if any)
    if (!emailsToSend.isEmpty()) {
        try {
            Messaging.sendEmail(emailsToSend);
            System.debug('Successfully sent ' + emailsToSend.size() + ' VIP welcome email(s)');
        } catch (Exception e) {
            System.debug('Error sending VIP welcome emails: ' + e.getMessage());
        }
    }
}