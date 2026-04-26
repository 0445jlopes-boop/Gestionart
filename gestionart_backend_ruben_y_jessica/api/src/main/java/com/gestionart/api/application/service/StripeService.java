package com.gestionart.api.application.service;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import org.springframework.stereotype.Service;

@Service
public class StripeService {

    public PaymentIntent crearPago() throws Exception {

        PaymentIntentCreateParams params =
            PaymentIntentCreateParams.builder()
                .setAmount(1000L) // 10.00 EUR (en céntimos)
                .setCurrency("eur")
                .setAutomaticPaymentMethods(
                    PaymentIntentCreateParams.AutomaticPaymentMethods
                        .builder()
                        .setEnabled(true)
                        .build()
                )
                .build();

        return PaymentIntent.create(params);
    }
}