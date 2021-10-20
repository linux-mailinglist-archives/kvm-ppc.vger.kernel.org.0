Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686354344B5
	for <lists+kvm-ppc@lfdr.de>; Wed, 20 Oct 2021 07:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhJTFiE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 Oct 2021 01:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhJTFiD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 20 Oct 2021 01:38:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BBDC06161C
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Oct 2021 22:35:49 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso1620602pjb.4
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Oct 2021 22:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=bj3hx8Y6AacG6Of7JEEk2v73n8thJfWW7BGtf0XwtkE=;
        b=gmS/KPHyQX7FAsqux0+YDviUifTY1ZMSSY+i/gfBMKYVFf2a4Fwv9JLzMdylQoSev4
         4lWtL6xuxhXp16Kvq7uLBrF/hVI9Y/yUrbBopHrkp3zxfyxyneFwNQvbT26PHOLurgpi
         RWwY4NOxQaPPG+vHtZazZU79EsojV8jehR5IYuHQc+PRZl1lvJbyRdjnBsdT4sMBp23P
         X1SMWOCJj2ZvrnBKna7nSSmBeHB9EFq0+3jCjHj/TbFWdsn/o6nxxRmMt+Dl+oVylalO
         SAz8QRYpVi3teFl8oc5B5kFPo9MvNM0mhDvVqnYMFQ428qKcwVbe9nXNUA/ZE8q3qV7H
         Bxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=bj3hx8Y6AacG6Of7JEEk2v73n8thJfWW7BGtf0XwtkE=;
        b=lsO8yMDrouUJVYaDZ9H4M3O8GU9KvkWJ3b49Rv2+3xO8Ld/MHtwUYa5q1Wy7DJVZKI
         BkZIrVUanhT/5pwI3CHiHchVjSfaGf78X4KMvFL70cV1UtBJ2Gm8RoJc4pIQ7XOrcG7N
         fDWPzilPDWuBKUXfcN2IVXBJoGCCUcWtg1SQtp2sZ06XSgdo822meB0ycrQ2A/AgLDqX
         KKsBs9UjyKz8hR9YyatYZN4GyX6AaaK7SIT/7rlm/DDF2kZbDl/caT63+mp/YAM/KdY2
         Sdr1R5AInySluJ+7Jc9RiCuKsRShzefu7qmuD195Mabya8uH2VYq1Arh7vWSpnUpBuI8
         Hj8w==
X-Gm-Message-State: AOAM531WO7S1KNQLB2WXvfxi6vXvfSiVBzZvTAVphsMX849ZpZ6nmVai
        lFx0BpYZl2L/WSpzTaln1so=
X-Google-Smtp-Source: ABdhPJyYWmPuvcR3GgqSyVpA+gZGrCHU3CwR3fhKX2mrZLKmHzLirQvZAhpvkqHlaJVtBIkmMlJJBA==
X-Received: by 2002:a17:90a:6b0b:: with SMTP id v11mr2419300pjj.178.1634708149510;
        Tue, 19 Oct 2021 22:35:49 -0700 (PDT)
Received: from localhost (14-203-144-177.static.tpgi.com.au. [14.203.144.177])
        by smtp.gmail.com with ESMTPSA id m11sm906035pga.27.2021.10.19.22.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 22:35:49 -0700 (PDT)
Date:   Wed, 20 Oct 2021 15:35:44 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 19/52] KVM: PPC: Book3S HV P9: Reduce mtmsrd
 instructions required to save host SPRs
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20211004160049.1338837-1-npiggin@gmail.com>
        <20211004160049.1338837-20-npiggin@gmail.com> <87r1clw0a7.fsf@linux.ibm.com>
In-Reply-To: <87r1clw0a7.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1634707623.6hcz0vobiz.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of October 16, 2021 11:45 pm:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> This reduces the number of mtmsrd required to enable facility bits when
>> saving/restoring registers, by having the KVM code set all bits up front
>> rather than using individual facility functions that set their particula=
r
>> MSR bits.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
>=20
> Aside: at msr_check_and_set what's with MSR_VSX always being implicitly
> set whenever MSR_FP is set? I get that it depends on MSR_FP, but if FP
> always implies VSX, then you could stop setting MSR_VSX in this patch.

Good question, this seems to come from quite old code and is carried
forward. I did not immediately see why, might have been to avoid
another mtmsrd operation if we later want to set VSX.

But the rule seems to be to set MSR_VSX if both FP and VEC are set, so
this seems a bit odd. __msr_check_and_clear similarly clears VSX if we=20
clear FP, but not if we clear VEC.

I might be good to remove that logic or turn it into warnings and make=20
sure the callers do the right thing. Not sure.

Thanks,
Nick
