Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BD863C922
	for <lists+kvm-ppc@lfdr.de>; Tue, 29 Nov 2022 21:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbiK2URm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 29 Nov 2022 15:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbiK2URa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 29 Nov 2022 15:17:30 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844176D971
        for <kvm-ppc@vger.kernel.org>; Tue, 29 Nov 2022 12:16:55 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id x6so4400818lji.10
        for <kvm-ppc@vger.kernel.org>; Tue, 29 Nov 2022 12:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=RTPG0QP7LZ32cfCOAzofH8luZz3/nLG08vWek8mzscp0530F+mpXLsjo8AyYBl7WZ/
         trvsIBBGpBC/0waQCRayrIpAjihCmK8DvtNYsGNLu23IOdgDog2+mW+2XU5vfrgjoggo
         0UC9qZM53TJFAK4D9FVO1bsdWQ1S6/yJze86V5g8L/7MPIdOq27AISVKGmJEMzl6XovV
         qwSS2sWaHXHelzDWozmz89Xawswa0PKnqhfR/hexK9NuRtVmOTtuRo/0G3hUxq3Ljt01
         qrBRIKfkC+XjtqJlBXcPRreU8H6b40882alQXIuPb7sxZ3swdMecQcY9c1X5+JwXSXMA
         GYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=YgVLLRBbx4nRCKrX65i11+h/T+v498WmI/WNo2t4lDjxhWThy9jLXAoB0lw9twea/v
         drnfl7uKqReeZABlufMPo7DOioJG34+/llBC7mPwOddS1AcRxZZwHhFrAdSxKvG5n2Vx
         wdxCTZsnCfPWao8uvOr2hcE1hKjFzLA3rxIv+B3LJvgK82stWKodWnes/bpUfmOFP93k
         Gi/Z5Re5J0wMSb6gMIoAOURxeOFhcutB+Kg4yFRcYuOunWCRu+V31py0KrtKGPGBBEcm
         1MutfdaGsFX9Wb5bemSTo7lqw78215wN+85N8o3BIEUQyH56oRmJ4bNmoE4vvSPdQFB/
         1NPA==
X-Gm-Message-State: ANoB5pmwGS+5X72k5prRwOVOBt2GBLG8B2u1mfTh14l6b7RYoXYdsAly
        D31klrv3P8feEF1ZlGGYmMikrE94Fs1YbtkCarE=
X-Google-Smtp-Source: AA0mqf7X10xZ2IKfzXS+xobLbfPRihwyjqP1Bjhi87KP9JDvAevgh3yTPH8Q3yt+uCQGQi0GCEqSbTam47nNan56pLw=
X-Received: by 2002:a05:651c:50b:b0:26c:5db6:cd84 with SMTP id
 o11-20020a05651c050b00b0026c5db6cd84mr13186663ljp.114.1669753013602; Tue, 29
 Nov 2022 12:16:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:651c:a0a:0:0:0:0 with HTTP; Tue, 29 Nov 2022 12:16:52
 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <chiogb00@gmail.com>
Date:   Tue, 29 Nov 2022 20:16:52 +0000
Message-ID: <CAAtWbkEAMQJDfs1SnRLup+F+=QL+vk1rnWR2uLOLtSa-JTS1nA@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
