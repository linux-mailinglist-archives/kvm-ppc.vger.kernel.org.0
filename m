Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D82E74C13A
	for <lists+kvm-ppc@lfdr.de>; Sun,  9 Jul 2023 08:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjGIGOX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 9 Jul 2023 02:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjGIGOW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 9 Jul 2023 02:14:22 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F71E1BE
        for <kvm-ppc@vger.kernel.org>; Sat,  8 Jul 2023 23:14:21 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id 4fb4d7f45d1cf-51d80d81d6eso4500057a12.1
        for <kvm-ppc@vger.kernel.org>; Sat, 08 Jul 2023 23:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688883260; x=1691475260;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBZ792TT73rLAClHQ60AjjRlJ2VQl3XCrrshrjXv0TE=;
        b=ImYsxmLC3wOVC065aVH4dcWr2F76De6OwIFFbuQrj768vhe9FKlmiUOSeeytl9J03u
         jO0zLy9lCpto1Gf2MxGfdMyRQh/05q3sCx9ngSu8WD734h6BD/eTxp4LLRZtURxc5S+h
         7ekBPIeb16qxkS7TZzWvrybtKOI/dggBA2DThVR+p5r1xbe3psyYHgCW80Fbt4KB4+hU
         71zdyxpCC8B5Un3G6GAzKk1YRKeBGxo8kBS30eRw9qFTkngEXciKktsrCEzAEQ+Q03hp
         0K7SZDx1KQGVSujyxpr2vIWf/dKAIeRvU5+iSGmuJ84k+6C+XL+x4NIK1L1pxS/H7V0a
         LDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688883260; x=1691475260;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hBZ792TT73rLAClHQ60AjjRlJ2VQl3XCrrshrjXv0TE=;
        b=J4AWcU3GyYPxFngKEH+NL8Ev7b+cWlQ2ul9vvxjubWBgi8lPUIVgBtrfpKyCgzRlA2
         WmdPrpymFWPvZ7s9slH+KX1HWXc7U36G/fe8B3o4V8kdb2Sr3Gkq6zv6fcAXKr540W9Q
         GKxz2qOxGBhlTE6+r1+Wo7V9gDap9cjZ8UGcoCxRwPxYNGbljR0HvOnYc67vqBP7PbUm
         e2SO50lUx3fUlc5AicWdaR9ha5ybWkGJE9TZL8QK8bk1ljvx/PDpy/Eyv9E/RINss3Jq
         Qa6DxR/sdXzJtd2lblwy2WQ4bEBNuOKoxNwd4r3UlStcKXZhiEruVS5o/vZVxLs1ctmB
         byNw==
X-Gm-Message-State: ABy/qLbTiI7JL4eGKW2kOdQnt0SdD0VzvI3TMo5tGLS125kSqcAO6h8z
        pnulfi07O+YUKe6wih7a3OEaee/7/evloJc9kfs=
X-Google-Smtp-Source: APBJJlFKD8zV23Gs0YE4b5JyboSRyJclNGKpUxopgvC5cZOP3CWNzfx08yOs2yrqUoRjmpWzu8fIEZCfx4Hn4TItQ80=
X-Received: by 2002:aa7:dbd2:0:b0:51d:a94b:f8f2 with SMTP id
 v18-20020aa7dbd2000000b0051da94bf8f2mr7818860edt.2.1688883259608; Sat, 08 Jul
 2023 23:14:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:8613:b0:50:6e56:ee with HTTP; Sat, 8 Jul 2023
 23:14:19 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <ninacoulibaly.info2022@gmail.com>
Date:   Sun, 9 Jul 2023 06:14:19 +0000
Message-ID: <CAA=mk0WQhRnGkNCbQSx5mGVFaaaLpH2vcTuNk4XbhFNYRwVTxA@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear,

I am interested to invest with you in your country with total trust
and i hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that i can give you my
proposed details of funding and others.

Best Regards.

Mrs. Nina Coulibaly
