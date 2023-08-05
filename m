Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE24E770E26
	for <lists+kvm-ppc@lfdr.de>; Sat,  5 Aug 2023 08:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjHEGlM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 5 Aug 2023 02:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjHEGlL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 5 Aug 2023 02:41:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7505B1BE
        for <kvm-ppc@vger.kernel.org>; Fri,  4 Aug 2023 23:41:10 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-52227884855so3769926a12.1
        for <kvm-ppc@vger.kernel.org>; Fri, 04 Aug 2023 23:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691217669; x=1691822469;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fyaf0OHfvWgaqfRiwRufcy49gz6rXRNyNLf1qH0Ffk0=;
        b=TQiCRlGjwqK/MRzt57YKjLwe8zIOGPxRhoripsZgedmClZ1KpoAw3vQw9H0ifmXXxI
         Jli2+3fxvBjZy+hiZe4vwbA98Oft0VNTZNAskcgpCBzdb1czmnAZx0Ox4v0r0uj1TSuK
         8PHVArU/7X6RxhfXeT/bK5gS2LU6bFIqI5D+ctEy1PA+iBKKjnx7Br7UzhT5IsCnyNpA
         aa+IkvdyrrMg6JmWlzjqdQyvGofwMdLE7pU53P+hp3Ykr+5sELVfw3CGq0iZa48IkBo4
         7FMckafx9yuM+UE0tC/vcxY4zl7OlD2rJNDFBKtqx+NeToFLug50S9d4V7MhTAZKvYQV
         s+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691217669; x=1691822469;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fyaf0OHfvWgaqfRiwRufcy49gz6rXRNyNLf1qH0Ffk0=;
        b=MbevIW/H3d2ZTk0UQlDBxFZkmbO+UsKE8ZrO0hbDn0KZrRHBNHGQffPCH7YA3svz42
         b+VdgdFawvsVAxnu9Bjm9jKvyZx/0todMQYmR2A+CmszI7OrZWa7xa6VbaYjQFa33Zns
         8oajaHpXiLpwLQBQCeamSqiRvjFC/Ws+sauSARWSKf0do3mNyc+3Mu97bJCgxXikxAUA
         2kWOGQbNjgWTMwofjc8V/DgAjiXQY+9y7l5wtpxTCOS6c4o6vkJDKa6ZUSW7nYEbQn/D
         3oI7+XkUKkMeVJCBFFtpFf/lCkmcltGQhJZoqfYZTvU0sy/8Q2uUWLw0ChaVdy3Q9k7t
         rrRg==
X-Gm-Message-State: AOJu0YweFjHSe6Sn3F5wOSUu+z5rZhght3GrmJK9yczAdSl3XR9TSNgv
        unh3yAYWmrcqnbDUeswdNr2amXYJ1D/4+mp6L8I=
X-Google-Smtp-Source: AGHT+IGThGCeulXHDA2H21wBdXxyTa+9LoXhcHTLS4DylUikLO+twgRiv2RzbMw514Y6WweRK9qsUfyaM/o4CYcx6cg=
X-Received: by 2002:aa7:c58a:0:b0:522:1bdd:d41a with SMTP id
 g10-20020aa7c58a000000b005221bddd41amr3227620edq.4.1691217668753; Fri, 04 Aug
 2023 23:41:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7412:6629:b0:df:940:19b1 with HTTP; Fri, 4 Aug 2023
 23:41:08 -0700 (PDT)
Reply-To: bintu37999@gmail.com
From:   Bintu Felicia <bimmtu@gmail.com>
Date:   Sat, 5 Aug 2023 07:41:08 +0100
Message-ID: <CAAF5RuyBFFhrXwDy20asdU1SrMyY9n9jdbAK6L2dYHmk5uq-Rg@mail.gmail.com>
Subject: HELLO...,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

How are you today? I hope you are fine. My name is Miss
Bintu Felicia . l am single looking for honest and nice
person whom i can partner with . I don't care about
your color, ethnicity, Status or Sex. Upon your reply to
this mail I will tell you more about myself and send you
more of my picture .I am sending you this beautiful mail
with a wish for much happiness
