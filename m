Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4DB6490B9
	for <lists+kvm-ppc@lfdr.de>; Sat, 10 Dec 2022 21:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLJUy2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 10 Dec 2022 15:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLJUyT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 10 Dec 2022 15:54:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A3117400
        for <kvm-ppc@vger.kernel.org>; Sat, 10 Dec 2022 12:54:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso8408778pjh.1
        for <kvm-ppc@vger.kernel.org>; Sat, 10 Dec 2022 12:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:reply-to:subject:mime-version:from:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9ZcJHwMhrgk/E0VwCU34SCQDGV0Eb07zFHX6T2T45Q=;
        b=puXGwlZd0NrayBOCBm5Jw79Q1ElXLf+p7QWzplS3kkONtyqkAlThUVSWwszTDTHSiQ
         aBBTb2cF9Fp5TElTMooZwYKIdW3B51fNDLDtP7v1KBiNojAPTls8OfnT61nPqTPDEWIW
         jya50axGdaOE8WhsU1BewNi1zTWh8T/MkUWYsRAGLoTqCGLjR1dIXaxmWTsJ4vnQ4pJX
         VKoGSlgwG2g1X1+aoEJsxFna3eVoat8ii83+qclfFvEZy3pFL8gSzbtHyv7kpKfd76VY
         NcgvaI3oDCl75Z1BEDguIYClgTEQWJJy0J6xqWYEOYhmSFTkFge7zM+80Ipa+rR11oqM
         mYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:reply-to:subject:mime-version:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9ZcJHwMhrgk/E0VwCU34SCQDGV0Eb07zFHX6T2T45Q=;
        b=WREJ5GWiEQrsfgIQBHvGrdtogrrpUuJX8Z3XGIazQa5/e4C9u4oGgQqyFn9AeifCiB
         d90BeWiKVlfmjl98YbC3qs7/Vs0OZZr3atdP/Qae4ZSVgp5PXIkIXSc1kLVDhYIOruXm
         gIjVG+iRUgj2Fk6d3z79mAkL6e6jr7fWRmr6DoE0iDB3l8zuAKEb9ge62HFNdqrXfuqH
         DgtWzG9sUwrdy+Usw2aWP28q2i3CvJWWpHZYmXTb2NIYAi0dhvGnb9Uryp2DR8w75Euo
         DIi+ZJmCFxOu+kU6SKpNzlkpBp6DC7BOGwvfSLfpO+w9OwBKPfh73SdioFvcv/+4zEPm
         QkdQ==
X-Gm-Message-State: ANoB5pkOIRVJ3/7PteDApKRoEqvJI6VTGdifMETiU/DOGvLd59UizLtc
        0QnzNEWAN2JCJKOt3/x/1J5FDjHB5hfxZI2G
X-Google-Smtp-Source: AA0mqf6GlfYb0W1QrhgJXLFTtSwPCYTqjPGcHPTWYxLgT1r2JDcN7h8Fhk+/mGczF9hig6YW15LaNw==
X-Received: by 2002:a05:6a20:9b87:b0:a5:418:833d with SMTP id mr7-20020a056a209b8700b000a50418833dmr11855895pzb.26.1670705658100;
        Sat, 10 Dec 2022 12:54:18 -0800 (PST)
Received: from [127.0.1.1] ([202.184.51.63])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090a7b8900b001fd6066284dsm2864132pjc.6.2022.12.10.12.54.17
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 12:54:17 -0800 (PST)
Message-ID: <6394f1f9.170a0220.c72d1.5881@mx.google.com>
Date:   Sat, 10 Dec 2022 12:54:17 -0800 (PST)
From:   Maria Chevchenko <17jackson5ive@gmail.com>
X-Google-Original-From: Maria Chevchenko <mariachevchenko417@outlook.com>
Content-Type: multipart/alternative; boundary="===============7854792163544814947=="
MIME-Version: 1.0
Subject: Compliment Of The Day,
Reply-To: Maria Chevchenko <mariachevchenko417@outlook.com>
To:     kvm-ppc@vger.kernel.org
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

--===============7854792163544814947==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Please, i need your help; I have important business/project information that i wish to share with you. And, I want you to handle the investment. 
  Please, reply back for more information about this.
  Thank you.
--===============7854792163544814947==--
