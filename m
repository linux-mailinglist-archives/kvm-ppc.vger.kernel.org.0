Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818F265EEEA
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Jan 2023 15:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjAEOjL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Jan 2023 09:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbjAEOi6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Jan 2023 09:38:58 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F078259D0D
        for <kvm-ppc@vger.kernel.org>; Thu,  5 Jan 2023 06:38:57 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id tz12so90518812ejc.9
        for <kvm-ppc@vger.kernel.org>; Thu, 05 Jan 2023 06:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JT2Gt7y/M3YLHVCyMzZwNsFe1p6EOvnpVpu2gl496w=;
        b=ZdtYMi4Bg7Buhts/SADDd9YJbN2+n8Gx8FDaRB4RZhisG2lqSpnyD9/FYUohnOsB1z
         QjlUEQVI+kdnGpLLBILmAlSChUNDOjh70XDOVvRAMGpP2U1doQ03mPMVW7nm9yWGQLMC
         85EOg3dNTwnAvgnC5LZPQgs2/St+bqi64P38EDYMFqUms8f0jjfGUj3K9fyyA75Rs/+y
         CMtUAd67m8bT5Dlq/y/0mLZBchQtJqz5IIv1VddmPey8rHpAXixhttn6Iz0QsTNOXSz7
         arhgqFGXb1/LtTnLiqFdlPP0Kd7I1XQ/0Ok8ie1uWf62SkgJqjlUahFh3ehvEyIUDZ7V
         qMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7JT2Gt7y/M3YLHVCyMzZwNsFe1p6EOvnpVpu2gl496w=;
        b=GZ99xg3+gKRa8beLHfGMZSccmcZuXSTX4PkgwiPRWA63uyt+vXq4BKnTHElvfNnV7Z
         fumRh+MtW8HB9zdDq4nduCvWgIO20SAOtfh268Yt/RJPH5fnrmv3wsr0bAat7BkzuYMA
         xkoh9IZCfeaG3G9UpE7FDVEI+VRwBkXT6RTc3IUaKrOlLZnd5hHp2S9mB8rujNyPRRSe
         Zhy/jJGAIq2P/ldNIqKXaV+ErC2/hVdD2VMBnDefyTi/3XCMQHnAWCbB9RKcR48tJUPd
         duPJLnGzR9rjldAgP+ERtT8ztNDGbqc9K5JNVhmb7r5Ttlwf6lXbmZVrgAXBWQeifClI
         pEEw==
X-Gm-Message-State: AFqh2kqJhhklG4aXsElSMhFsj17PNpVyq9SG9ymEOnV8hTU6RQiRMkOd
        OZH4L/JdwKh0zJ+T6OTVQyN2wzpC8UqvKiuHMtQ245VRO4EcBA==
X-Google-Smtp-Source: AMrXdXuUngYQxVt3QiluyJuoZDhA0e1xHX+pyF7QYlm9IsFcuSCT/UMpJncrFEOYml+avs5K467sdL4ZoFhrMafDIxU=
X-Received: by 2002:a17:907:9505:b0:84d:df4:288c with SMTP id
 ew5-20020a170907950500b0084d0df4288cmr116472ejc.140.1672929526106; Thu, 05
 Jan 2023 06:38:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:640c:1b82:b0:19d:c2ad:4d35 with HTTP; Thu, 5 Jan 2023
 06:38:45 -0800 (PST)
Reply-To: westernuniontransfer277@gmail.com
From:   Western Union Agent <moussanezirou960@gmail.com>
Date:   Thu, 5 Jan 2023 06:38:45 -0800
Message-ID: <CALCeEFaDe3EiXPHBxq4Y_t0Pa2xzP3eGokYmX3aKkyqm+cfNiA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Good day dear,

This is to let you know that your payment is ready now, but we need
your details now so we can complete your transfer today without
no error, so please try to send us your information now
so we can continue.

We hope to confirm your information now.

Cheers,
Western Union Agent.
