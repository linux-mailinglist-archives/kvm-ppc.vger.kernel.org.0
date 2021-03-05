Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A055732E0D7
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 05:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCEEpK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 23:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEpJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 23:45:09 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4782BC061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 20:45:09 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t29so1119119pfg.11
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 20:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=dvhZCW02cSrw6wLow/cEYL9mfdL94hp8q7KDEYz2Ow8=;
        b=Ofh1HiszzfsRjiIh19nlP00q27z2AjN9ixQ5PbTck4BoMfICPe24qzyw4hxz7BN4iy
         4HgKR218h/CLUDMdxb+E1qzYlqOK4uhnZbmWKbe6KMQvxj5VzRzWBlrntxgdhkITFCub
         IJlomiPVLta7MItAWR9IsnBEdvt69yW/Z3ry0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dvhZCW02cSrw6wLow/cEYL9mfdL94hp8q7KDEYz2Ow8=;
        b=jYcwO4nwvNuikIGkjvl2PgNSlK9iPSj/uSinoG6IVBYiQC4fOYf3noXwOeAc/SZ+Xs
         Jy8FROl1pVOcXtW76zCyf+SVGEaFClpDnT+Wffv/rHi9fqrftz1RX9VndqOnEnPgqWHP
         Cp/mWvfKk5nRzePXj98HoZefhksJ5OHjDB1Gzt34kXjZBx70LhSXt6WXsB9a6kg8O8j4
         Hk1eEeNKyw/qKaW23ASo6GTYYJHkhXemDGbEmqoJpJO91Q4MEZ/idChCuWR5fXLrrNBG
         po73J1ON6pZWhwg9prRxBwzsUiSU44dcBgUtyGZLzqmOWUN0KJgbSpalwEPdiPwmp3n/
         iEkA==
X-Gm-Message-State: AOAM530ZkUW6ZL53kkY5oXGpc3cP9sK3YIDexY902oMa0nEH07tun5Zu
        DyAb9+4J77Pa97P6vJaO33/cTg==
X-Google-Smtp-Source: ABdhPJzOnn++HWmEOHHjEvLODI9XCRbZBmiVKcug1fqDhp74nCyoW8Wrn+8XCSllNEy+VlP3GElKMw==
X-Received: by 2002:a63:4f56:: with SMTP id p22mr6844756pgl.224.1614919508812;
        Thu, 04 Mar 2021 20:45:08 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id f19sm885685pgl.49.2021.03.04.20.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:45:08 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 01/37] KVM: PPC: Book3S 64: remove unused kvmppc_h_protect argument
In-Reply-To: <1614383256.cikqwycx8o.astroid@bobo.none>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-2-npiggin@gmail.com> <878s7ba0cm.fsf@linkitivity.dja.id.au> <1614383256.cikqwycx8o.astroid@bobo.none>
Date:   Fri, 05 Mar 2021 15:45:05 +1100
Message-ID: <87wnum8azy.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

>> ERROR: code indent should use tabs where possible
>> #25: FILE: arch/powerpc/include/asm/kvm_ppc.h:770:
>> +                      unsigned long pte_index, unsigned long avpn);$
>> 
>> WARNING: please, no spaces at the start of a line
>> #25: FILE: arch/powerpc/include/asm/kvm_ppc.h:770:
>> +                      unsigned long pte_index, unsigned long avpn);$
>
> All the declarations are using the same style in this file so I think
> I'll leave it for someone to do a cleanup patch on. Okay?

Huh, right you are. In that case:
Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel
