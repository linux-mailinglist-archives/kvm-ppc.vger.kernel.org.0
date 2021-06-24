Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78E63B2C45
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 12:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhFXKUI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 06:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbhFXKUH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 06:20:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5891C061574;
        Thu, 24 Jun 2021 03:17:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bb20so3183730pjb.3;
        Thu, 24 Jun 2021 03:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=ufPcep0sp8fFam4s8EQWkn+673yXecgGkFHNTHQONWw=;
        b=sFF5ZYvJivSW9geCDpAWHQIXJqy0TaWKJDeCWyf+SN8sC0zvAWOqxE0kDzVGrlqH0T
         tmnXDqy/vMEUI/QT1fg3tuAhH6y/WaFDv0bhKrmNY65hIUEPGulyXJKnytExJVEwigXZ
         EEgjb92CecGE/1ZNSefvvxGTeh5Bu3j4pd19HStH0J6gJv+4gmTPMVXvpU/FEf57f6Z1
         yZZLHMoK9YK0EH+XiEgmNblrEYdl95qc0I5aDyKhqYAvytW6+/07zmQXw9lEc1D57uv2
         sPH/vR/v0oM7LuQHI7hajV/RDoziumHUY8ZgFdgAAJLR7DiFovRTgo8M2LsLunQ7LnIe
         UNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=ufPcep0sp8fFam4s8EQWkn+673yXecgGkFHNTHQONWw=;
        b=aS4wwhJvFaUFn1MsoE7emCf6T3BPewsDquwyDWjz/J+NRe5hMNKkj1Aljz2Ecau/6o
         NtcLlZNgPkgqdfbcHC6TVEajAYSfy/mjGHddIXWFPj7gF0JJtYu/ONbVbtSbYt0+w+yj
         G7rAdFNbHSgL66Og7y1N0Bwt7SIlAeUsOb/kZjcxJCCArcCvfdcw1jxqJAdbR3PD04F7
         2mgPmVbmrjvIlaQfUFe2Ioau0LS2Ipyjl4wuguEZ+EunSb6xZYbjUW73hI5Zfc0F2N+s
         zy8XDR5lGlapmye5SxnTbZF4b850jgbtXcUs+eDhht7xH64xuiZqwXn5/721xM71I0kk
         4yMA==
X-Gm-Message-State: AOAM530byPkbedOQkTcbexzeHypJpzrl6qUbpXF6/nyvKyPIOaD2EVGw
        K7LiZoqxL3LZatqq77gNaq8=
X-Google-Smtp-Source: ABdhPJzBDdHKwzOfU1IGTH+/PPCRK2jVsTxYoY95EuRzqDADJIdiFOBloV8Ki52/MFkR99nX/DL1Xg==
X-Received: by 2002:a17:90a:7401:: with SMTP id a1mr14554343pjg.57.1624529868549;
        Thu, 24 Jun 2021 03:17:48 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id o20sm2094410pjq.57.2021.06.24.03.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 03:17:48 -0700 (PDT)
Date:   Thu, 24 Jun 2021 20:17:42 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
        <20210624035749.4054934-3-stevensd@google.com>
        <1624524331.zsin3qejl9.astroid@bobo.none>
        <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
        <1624528342.s2ezcyp90x.astroid@bobo.none>
In-Reply-To: <1624528342.s2ezcyp90x.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1624529635.75a1ann91v.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of June 24, 2021 7:57 pm:
> Excerpts from Paolo Bonzini's message of June 24, 2021 7:42 pm:
>> On 24/06/21 10:52, Nicholas Piggin wrote:
>>>> For now, wrap all calls to gfn_to_pfn functions in the new helper
>>>> function. Callers which don't need the page struct will be updated in
>>>> follow-up patches.
>>> Hmm. You mean callers that do need the page will be updated? Normally
>>> if there will be leftover users that don't need the struct page then
>>> you would go the other way and keep the old call the same, and add a ne=
w
>>> one (gfn_to_pfn_page) just for those that need it.
>>=20
>> Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so=20
>> it's a good idea to move the short name to the common case and the ugly=20
>> kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not=
=20
>> sure there should be any kvm_pfn_page_unwrap in the end.
>=20
> If all callers were updated that is one thing, but from the changelog
> it sounds like that would not happen and there would be some gfn_to_pfn
> users left over.
>=20
> But yes in the end you would either need to make gfn_to_pfn never return
> a page found via follow_pte, or change all callers to the new way. If=20
> the plan is for the latter then I guess that's fine.

Actually in that case anyway I don't see the need -- the existence of
gfn_to_pfn is enough to know it might be buggy. It can just as easily
be grepped for as kvm_pfn_page_unwrap. And are gfn_to_page cases also
vulernable to the same issue?

So I think it could be marked deprecated or something if not everything=20
will be converted in the one series, and don't need to touch all that=20
arch code with this patch.

Thanks,
Nick
