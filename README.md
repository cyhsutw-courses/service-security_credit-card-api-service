# Credit Card API

### Usage
	
The base URL of the API is https://credit-card-api.herokuapp.com.

Use the following route to access the credit card validation function:

#### Request Path

```
/api/v1/credit_card/validate
```

#### Parameters

| Name          | Value                   |
|:-------------:|:-----------------------:| 
| `card_number` | Your credit card number |

#### Response

| Status Code | Body                                         |
|:-----------:|:--------------------------------------------:|
| 200         | JSON with card number and validation result  |
| 400         | `empty`                                      |


	
