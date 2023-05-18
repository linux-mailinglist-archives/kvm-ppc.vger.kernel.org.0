Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB55C707CC5
	for <lists+kvm-ppc@lfdr.de>; Thu, 18 May 2023 11:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjERJ1E (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 18 May 2023 05:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjERJ1C (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 18 May 2023 05:27:02 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1E72127
        for <kvm-ppc@vger.kernel.org>; Thu, 18 May 2023 02:26:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50c8d87c775so2590441a12.3
        for <kvm-ppc@vger.kernel.org>; Thu, 18 May 2023 02:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684402015; x=1686994015;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYlqmqzmZQIzuckqyml+D+cUQfB/LAmhyfGQVjeCZAE=;
        b=c/gtEJRTFgJj3jBTgDJ/yKPiQy3O5ebA/lEPkBVOy+U6548jw7u3SieQ2Ry/9ykImh
         pEDEgvp4M4UcqwjlzKoKPGbVas/pDnVp6WY25v9VrPod1R8jBdGePSemv9j9ZjINpdQD
         OAlLewcM7FC0q5cuHyeZ47862hglM4sgK8E55Tx25bLaux+UFi43G26M+B+NF68lnxRK
         bYYrbKHnTxznL8pUstRAwNqvrtDtkPOaWCM42xVWIQvfO/ZwOLG/g/lajbYy9MXK+sta
         1LAwfq3W0OfoYjSxh1YhvFXzaqAbNWdnoK+bSXpOKLmy8Ir2CJXFS+RTDIbYm6fvk896
         gCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684402015; x=1686994015;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYlqmqzmZQIzuckqyml+D+cUQfB/LAmhyfGQVjeCZAE=;
        b=mHHxhd5d46LaxFUVQwC6/yrd27HlSTSpIR/bxsKOCMUxPF20GW1+/4pUVrdB3lw8/m
         l+6SHOZ0yBqgmiFvCczuG613paXHps/TmgbJ59gzZ9JorOo5HbzrpUQ9Fd6uktRqAkzv
         Ww3CqL7WsBv31RMt6pCg7ZsVXJdXLN4i6jqwmAAwuItIqsy4tLMAzXyQPKmQOGbpvhCt
         AVQgU9fKqZkFVkP2rhG0xCnpcMyMfJRqwisf65WkPfRz4K0sxNmu7o3tRRhrDUn5IZkW
         o5M2BXXLpMgrJnIVJ3np8XCO8agaKZDJ3s0ggNC1A2LuQA8i6a9GS/uvAakHwcg5b3qr
         aycQ==
X-Gm-Message-State: AC+VfDyT5B/eCj2GUEujGs1YSg85/gQ7ZtHL15LH5Gp4TWFdGBvGu0tU
        7hUCdkSPTOqkqeJ8AFQB3DC9gZ77h7rJRU8e6KI=
X-Google-Smtp-Source: ACHHUZ6abYnTAtGz3hvBHixNLiP68PwNVt9KqJD0dXTBWV0s+ZCr8W9iccw2OyNOkghZJbH3wSk1UynSxe9+on1XS9g=
X-Received: by 2002:a05:6402:194:b0:50d:89c9:6387 with SMTP id
 r20-20020a056402019400b0050d89c96387mr5126618edv.27.1684402015331; Thu, 18
 May 2023 02:26:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:dace:b0:94a:7e28:ef2d with HTTP; Thu, 18 May 2023
 02:26:54 -0700 (PDT)
Reply-To: ninacoulibaly03@myself.com
From:   nina coulibaly <ninacoulibaly013@gmail.com>
Date:   Thu, 18 May 2023 02:26:54 -0700
Message-ID: <CAHS6EwU4QAMG2+mfmiPet9+mhxmDWwVYGkO8D7bga+LxqCTWfA@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibaly
