---
title: "Gmail_with_R"
author: "Pankaj Shah"
date: "6/11/2019"
output:
  pdf_document: default
  html_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r, message=FALSE}
## Installing the gmailr package if not already installed
if ("gmailr" %in% rownames(installed.packages()) == FALSE) {
    install.packages("gmailr")
}
library(gmailr)
```

Head to this Websites:

1. https://console.developers.google.com
2. Enable APIs and Services.
3. Search for Gmail API.
4. Be in right Project Folder. Otherwise Create One.
4. For the first time user : You should Enable. If you already have enabled then you head to Manage 
5. On far  top right hit create Credentials.
6. Choose Client ID. (https://developers.google.com/identity/protocols/OAuth2?hl=en_US) # Be in Same project folder and have same Project Name.
7. Choose Other as we don't have Rstudio option
8. You will get code either copy paste or save as json format as I did below **Test_Email.json**


# Access to the secret Password File.
```{r}
use_secret_file("~/Downloads/Test_Email.json")
```

```{r}

message_to_be_sent <- ("Hey Is this mail look spam to you or is it Ham. Lets try the break function if this works we should have break in between the lines and the code that we run and function and I tried the html but the function seems to be not working")

my_email_message <- mime() %>% 
  to("pankajautomatic@gmail.com") %>%  # you might need to authorise couple of pop up screen from the google.
  from("pankajautomatic@gmail.com") %>% 
  subject("Test Message") %>% 
  text_body(message_to_be_sent)

send_message(my_email_message)
```

# HTML Message Text
```{r}

# Some how the HMTL text is not working at the moment

html_text_message <- ("<p>This should be paragraph.</p>")

my_html_message <- mime() %>% 
  to("pankajautomatic@gmail.com") %>% 
  from("pankajautomatic@gmail.com") %>% 
  subject("Test Message") %>% 
  html_body(html_text_message)

#send_message(my_html_message)

html_text_message
my_html_message
```

# Attachment
```{r}
message_to_be_sent <- ("Hey IS this mail look spam to you or is it Ham. Attaching the screenshot.png")

my_email_message <- mime() %>% 
  to("pankajautomatic@gmail.com") %>% 
  from("pankajautomatic@gmail.com") %>% 
  subject("Test Message") %>% 
  text_body(message_to_be_sent) %>% 
  attach_part(message_to_be_sent) %>% 
  attach_file("~/Desktop/Screen Shot 2019-06-03 at 7.46.44 PM.png")

send_message(my_email_message)
```

```{r}

```

```{r}

```

