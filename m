Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65C3351252
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 11:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhDAJcs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 05:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbhDAJci (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 05:32:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54065C0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 02:32:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ha17so854578pjb.2
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 02:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=luTQUHifrHnpdtbLI7RXY3Sg49M9JDmTNAl2wiUsM/Y=;
        b=U2Sfk7Iyt0AJQFnp46JtB527hI5ws8C5B+iGnNYXtOVMlJ6sRnME3pCqfzQpNUPP8r
         QjpiMlqW7ZPsXBgSe0jGgAQv6TJC2DpbM8nhX37osal26NIgtvQM2nLdxTcjOqYLE17O
         QkMIfGPxTfY9tJpXf/CbUn/WExdU28LaoVkBxMDBo9v0l8hS8V3HNAwzZHIvN83CRUVU
         4aG/nCwmsQdGCTYU1FVOkPdaYgTDglMBBAZPoXd7j+UdN7FUGLvTpl2TntNiyubZj+9U
         LyMBpx4C5MsD23Zv727rqjc2Kmbvn1Iufcxchy9+gc+GluJLIMscWynWFpOTwBmJbBby
         zQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=luTQUHifrHnpdtbLI7RXY3Sg49M9JDmTNAl2wiUsM/Y=;
        b=ks7sq3ioFOAsfgFwyjwhZXMwzInNn3uNEiTucmkt6HqRoYGPnjrp9Oo3jxFLONqeiN
         bS3kEh+cb/iI8++z8qBlDrF8t7rkylb52rZN0MiSOTsXjo/3Hlpq31gd42uiTXFytFlv
         ISnkGi2mg5okwiwS4a5rT2wA3fsi0tSZtzrrC0Nk2LxLL86oMXdn6meGPaDCxo8fmkUb
         N/kyYOZ6dj5+OMcnhX/B6hx0jonRfyVVgO2DKDwx9jKn4vYrXUL7sqLpCtYZbmNiunPI
         voDOq+Cy6k86/WXMPU9beObxHMmY2UxJJIX+Yyd4IUXhG/HNKKhmfxVYzSWi69DC7Seu
         PIcA==
X-Gm-Message-State: AOAM531/wliMiCetzNJqP9/X44AIdRt6TFyZBLH2ihzhGA9XM4LT8MYB
        c4QQ3va3c8zvNZdJPCngNqFYCbpe6Xm3ZQ==
X-Google-Smtp-Source: ABdhPJzhWFv4wuxxWdGEZnVivQC26z7reqle1AE0mUUja4SZ5XFGYQ6o1IiZM69HlC2yPpUyi/4uxg==
X-Received: by 2002:a17:902:7585:b029:e6:cc10:61fe with SMTP id j5-20020a1709027585b02900e6cc1061femr7126563pll.23.1617269557932;
        Thu, 01 Apr 2021 02:32:37 -0700 (PDT)
Received: from localhost ([1.128.218.227])
        by smtp.gmail.com with ESMTPSA id i7sm4771210pgq.16.2021.04.01.02.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 02:32:37 -0700 (PDT)
Date:   Thu, 01 Apr 2021 19:32:32 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 02/46] KVM: PPC: Book3S HV: Add a function to filter
 guest LPCR bits
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-3-npiggin@gmail.com>
        <YGP1uXH5q72auwP7@thinks.paulus.ozlabs.org>
In-Reply-To: <YGP1uXH5q72auwP7@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1617269036.86nd07dbhp.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of March 31, 2021 2:08 pm:
> On Tue, Mar 23, 2021 at 11:02:21AM +1000, Nicholas Piggin wrote:
>> Guest LPCR depends on hardware type, and future changes will add
>> restrictions based on errata and guest MMU mode. Move this logic
>> to a common function and use it for the cases where the guest
>> wants to update its LPCR (or the LPCR of a nested guest).
>=20
> [snip]
>=20
>> @@ -4641,8 +4662,9 @@ void kvmppc_update_lpcr(struct kvm *kvm, unsigned =
long lpcr, unsigned long mask)
>>  		struct kvmppc_vcore *vc =3D kvm->arch.vcores[i];
>>  		if (!vc)
>>  			continue;
>> +
>>  		spin_lock(&vc->lock);
>> -		vc->lpcr =3D (vc->lpcr & ~mask) | lpcr;
>> +		vc->lpcr =3D kvmppc_filter_lpcr_hv(vc, (vc->lpcr & ~mask) | lpcr);
>=20
> This change seems unnecessary, since kvmppc_update_lpcr is called only
> to update MMU configuration bits, not as a result of any action by
> userspace or a nested hypervisor.  It's also beyond the scope of what
> was mentioned in the commit message.

I didn't think it was outside the spirit of the patch, but yes
only the guest update LPCR case was enumerated. Would it be more=20
consistent to add it to the changelog and leave it in here or would
you prefer it left out until there is a real use?

The intention is a single location to add some of these things
(handwaving: say tlbie doesn't work on some chip and we want to=20
emulate it for old guests we could clear GTSE).

Thanks,
Nick
