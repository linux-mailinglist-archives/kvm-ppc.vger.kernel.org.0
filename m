Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6120F403
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 13:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733250AbgF3L5V (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Jun 2020 07:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733215AbgF3L5Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Jun 2020 07:57:16 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DDFC061755
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:57:15 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l2so17825638wmf.0
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=97tTPxeIJ1A0X7anydjSG6FFQp1gQOx/xNszALEY9jY=;
        b=Sc0sBA2Y2XJ97+//1rj0qU7M3+vt0zDkUwHHXOGzsdBwXMVhQyqgdgmGPBcPmGb2Ad
         kDmTosxXmHp+k73MidE3puQ8oSZEI9zswHnCZWGPuV0MwSbpkW0g0AiWCjzrOWRq1rFu
         7gwpSzKYQJRrikuHYod+NCxQkf4vezhCfkeQ3H14grXQcp5kRo9tzGbUHC1M0ezufj/e
         m6SUPqvJHzhJmnwKBUDmiMLaso/1HU117qUqcjIRjqHQqKTJ4yN4MUNHEBnPGE36+ia7
         5f0foj88sWIkjhME19Elqy42yc14AVCY/3avwmsk77VdYQArHqyRT2CfLBkUipj2Z847
         eKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=97tTPxeIJ1A0X7anydjSG6FFQp1gQOx/xNszALEY9jY=;
        b=WGg/8JCE65Ttbvs4R9v92IbjQsWNm9LsXEG9gU/IEG3KSxFia9RtaHNWT6Zr5edmkA
         qO6Vzo36AYL50d3XIXe1r/QqoBHJF7Qg67fb1c5GO699BzIeTKLYgbF1Ea+hAVxAw7jC
         CYMnQSoK/g2FdvuanwfL4Glsk1uj5EX5xP+Qn/Fy4cttyJKt4NZ75UkH28Dpu2o/cfLL
         qqqNdVm+suEwkD0OpIz1ilnoW4Sl3SpMwPbg8IeEsxkPcZ7UmMpdId9y6x4jWxe86WKH
         uOkPXlpNvBNh9Gbn301S5ixxbeM3vZrfu5c8oJNQCOrC19C2oyQtz9dtuE4cGsZ/zqlI
         pBZg==
X-Gm-Message-State: AOAM530gXjIQbdvE0xjV/LPkc6rG+gfjqczvdkM1pt2+SgMvVQawKIPY
        2x1kxotiODd+c1z7eMy+2CE=
X-Google-Smtp-Source: ABdhPJyK5JhGYvcj99uHYMU4dkCK1vr72vskj+rGv0xZe0QUP+vOZlILFx5HwTQCtZN9oC/KvD0vzw==
X-Received: by 2002:a05:600c:2118:: with SMTP id u24mr7767485wml.133.1593518234262;
        Tue, 30 Jun 2020 04:57:14 -0700 (PDT)
Received: from localhost (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id v11sm40299584wmb.3.2020.06.30.04.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 04:57:13 -0700 (PDT)
Date:   Tue, 30 Jun 2020 21:57:06 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/3] powerpc/pseries: Add KVM guest doorbell restrictions
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Anton Blanchard <anton@linux.ibm.com>,
        =?iso-8859-1?q?C=E9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20200627150428.2525192-1-npiggin@gmail.com>
        <20200627150428.2525192-4-npiggin@gmail.com>
        <20200630022713.GA618342@thinks.paulus.ozlabs.org>
        <1593495049.cacw882re0.astroid@bobo.none>
        <20200630082607.GB618342@thinks.paulus.ozlabs.org>
In-Reply-To: <20200630082607.GB618342@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1593518201.ez0344yx91.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of June 30, 2020 6:26 pm:
> On Tue, Jun 30, 2020 at 03:35:08PM +1000, Nicholas Piggin wrote:
>> Excerpts from Paul Mackerras's message of June 30, 2020 12:27 pm:
>> > On Sun, Jun 28, 2020 at 01:04:28AM +1000, Nicholas Piggin wrote:
>> >> KVM guests have certain restrictions and performance quirks when
>> >> using doorbells. This patch tests for KVM environment in doorbell
>> >> setup, and optimises IPI performance:
>> >>=20
>> >>  - PowerVM guests may now use doorbells even if they are secure.
>> >>=20
>> >>  - KVM guests no longer use doorbells if XIVE is available.
>> >=20
>> > It seems, from the fact that you completely remove
>> > kvm_para_available(), that you perhaps haven't tried building with
>> > CONFIG_KVM_GUEST=3Dy.
>>=20
>> It's still there and builds:
>=20
> OK, good, I missed that.
>=20
>> static inline int kvm_para_available(void)
>> {
>>         return IS_ENABLED(CONFIG_KVM_GUEST) && is_kvm_guest();
>> }
>>=20
>> but...
>>=20
>> > Somewhat confusingly, that option is not used or
>> > needed when building for a PAPR guest (i.e. the "pseries" platform)
>> > but is used on non-IBM platforms using the "epapr" hypervisor
>> > interface.
>>=20
>> ... is_kvm_guest() returns false on !PSERIES now.
>=20
> And therefore kvm_para_available() returns false on all the platforms
> where the code that depends on it could actually be used.
>=20
> It's not correct to assume that !PSERIES means not a KVM guest.

Yep, thanks for catching it.

>> Not intended
>> to break EPAPR. I'm not sure of a good way to share this between
>> EPAPR and PSERIES, I might just make a copy of it but I'll see.
>=20
> OK, so you're doing a new version?

Just sent.

Thanks,
Nick
