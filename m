Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2084A63957C
	for <lists+kvm-ppc@lfdr.de>; Sat, 26 Nov 2022 11:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKZKpu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 26 Nov 2022 05:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiKZKpZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 26 Nov 2022 05:45:25 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6444A2CC8E
        for <kvm-ppc@vger.kernel.org>; Sat, 26 Nov 2022 02:43:52 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id g65so5948632vsc.11
        for <kvm-ppc@vger.kernel.org>; Sat, 26 Nov 2022 02:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wlb4SYlCkKFrC3vDbrNKcnlsbFr9aWDknzVh2AdUFE=;
        b=WvINcUrUmJp8f3HA0HVpwuL/pNScCK8B6mQXBcnrtpVQeMvPs268i/PLsH0lBFREat
         fM8c3pB4QcecTuKMQo8kTvaMfrJl7kAA8nilpvkf9EHcbYPiEFDzp8lOu1ZX8i2Yq5Ey
         Vk+i0JNDebOyNOKvDKtTobPOKfp44A7hQFdIjWWFmoobwJAU3bn5amDP7M4Wxldi4gvm
         RenQRkHYezmZx2Dv6/R52z7A52lXPPWfkXTovTMbBrMbRXqEKZDr11mjwvm5sgP3dfc1
         jyNdQTKeHukpO5sCFd+bRZzuP3fP8E75dWpmjeb4t5UkRRoIj8X9hlV4zD+RBuQHbBWL
         1U5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wlb4SYlCkKFrC3vDbrNKcnlsbFr9aWDknzVh2AdUFE=;
        b=1Nvv7hzv66S0yjOQnBBsJK7cT7ovZXCLtBJBX3bgfXD9fMgs8Ggzfqn84VZynQBcAK
         eiufhcu2OZiUUMzuV3jcGAhqVLa+5ZoY/mS9IzBK/m6dyxiRcmL1vCUVw4NeYhJesbJJ
         968OlxSpBi2/03RptLOMYoOpx/esWIINZnhhLV/aVkwgL6yVkG2+wJqtZz1DsciuXC9x
         sUO2jr3ySyLSX5TIL5ZQO+8ADtz1vpjiZuEj0JBJi4fc/Bl6lui2SUczeMJYqvjAXlvb
         rfmBCSkvkbj0OpynS3dNzogwBdVVzKb3V8TVwLhPC91iBa2ZY54cqrBVIvdoel6TRodS
         hZVw==
X-Gm-Message-State: ANoB5pmxXPj5wUOIUiIk9LHWARFMxZL6D2gdgOy7F6lYVSUVT3rYi88x
        GVa8Z04xjNxekDb9W/u1rr17cFyLLiihboKq/A8=
X-Google-Smtp-Source: AA0mqf7u4xRvAvqScCRPW1b50BJVyu+SPa1c+ZW9a++Nqjp4TD5rUZzo1ecsnsAupJa7HubdFmrW6MU0d+I8+2vyigk=
X-Received: by 2002:a05:6102:21d3:b0:3b0:81b8:e2a1 with SMTP id
 r19-20020a05610221d300b003b081b8e2a1mr5216915vsg.19.1669459431432; Sat, 26
 Nov 2022 02:43:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:1e4a:0:b0:418:a433:d6f5 with HTTP; Sat, 26 Nov 2022
 02:43:50 -0800 (PST)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <ninacoulibaly211@gmail.com>
Date:   Sat, 26 Nov 2022 10:43:50 +0000
Message-ID: <CACmoC-2w-zTBCNKVppZuwA4UYOt=nnf9uMoKXfxAuBfaJs+zCQ@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

-- 
Dear,

I am interested to invest with you in your country with total trust
and i hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that i can give you my
proposed details of funding and others.

Best Regards.

Mrs Nina Coulibaly
