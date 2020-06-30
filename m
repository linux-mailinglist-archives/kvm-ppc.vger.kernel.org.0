Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89520ED9A
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 07:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgF3FfP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Jun 2020 01:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgF3FfP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Jun 2020 01:35:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6918DC061755
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Jun 2020 22:35:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x3so3392338pfo.9
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Jun 2020 22:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=s00P0DjaGSC7vdiXdVQwK+g6WJ0VNDWILQPhUuEX0K4=;
        b=GXVYAQau0kxqZWFt//4uddyCAlpqvNlXjO+K74nVM0iUlZr7FuGDsSTvDbOCYtISE8
         +yV7mTNtOmeKqrpuVpTvV4SKFPF8MkWUoyWIJ1oMqAPxpyv/8zHdyMDq24/w7ti3/KDn
         upoEKvmXXxSFPbiQWEcpGxJoq1RZJtxVLsqWSW3cJA2zWP1SOQjheciySIH7kQaYJgUb
         HQEdluIniVpZG36Zp4lmjRqcfUIxnDlTpp4e5wlpyTyVigCzP5qKlJHQvroAVW03l6iw
         u6G4MAUpkctI/VTUi+suuncsB8bg7YAqwQtdQuiYC1EYjutl/iJe+TQWe46AyxJVIX4r
         xwtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=s00P0DjaGSC7vdiXdVQwK+g6WJ0VNDWILQPhUuEX0K4=;
        b=mf+2Xz71yK20SeNnljybEVpEVBaPl9jv9xqgSUnzBCv78KgWSenZwml5WoVTMfz/ZN
         r1lxrZhXIThPcvTsTPRigKSgEjdn43DcCHMj6hBU1OLKPJ5sR3jyg9L39zqf2ZzW5idA
         WpB3oIUEHchhhoRSEmdtSUbgA1yO4Ed/JY6AQATTxJVnsKul8sCnAgnQbeKmJnet1ixO
         LcuKFGgk3ivIOtmrSd19MXfwPUf1dBq+qnZDqo1POsiVfJlUnKrNKIa8qzCJL+bJehMk
         vnR+XM04w8qJqkoZdKpWGWL9YjN2q/yNuvqHqCDvejpBeRj2G6H9mwL+ca3i6S6zhgi4
         3a/g==
X-Gm-Message-State: AOAM5339UlFhBFn66wxlgWQFjIgY2W1Pcew/G3DALLWeOsGTAqdt1r2I
        yq9fleeYNt3/Tl+zM47qDPQ=
X-Google-Smtp-Source: ABdhPJzHwwNeTokySopi+E1W3pQs42+38f8CKWP93EMiZw3DeA3Fdk/LyfS5+OPvl5Fa/XvAz29zdA==
X-Received: by 2002:a63:aa42:: with SMTP id x2mr13017666pgo.361.1593495314689;
        Mon, 29 Jun 2020 22:35:14 -0700 (PDT)
Received: from localhost (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id c12sm1292038pfn.162.2020.06.29.22.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 22:35:13 -0700 (PDT)
Date:   Tue, 30 Jun 2020 15:35:08 +1000
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
In-Reply-To: <20200630022713.GA618342@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1593495049.cacw882re0.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of June 30, 2020 12:27 pm:
> On Sun, Jun 28, 2020 at 01:04:28AM +1000, Nicholas Piggin wrote:
>> KVM guests have certain restrictions and performance quirks when
>> using doorbells. This patch tests for KVM environment in doorbell
>> setup, and optimises IPI performance:
>>=20
>>  - PowerVM guests may now use doorbells even if they are secure.
>>=20
>>  - KVM guests no longer use doorbells if XIVE is available.
>=20
> It seems, from the fact that you completely remove
> kvm_para_available(), that you perhaps haven't tried building with
> CONFIG_KVM_GUEST=3Dy.

It's still there and builds:

static inline int kvm_para_available(void)
{
        return IS_ENABLED(CONFIG_KVM_GUEST) && is_kvm_guest();
}

but...

> Somewhat confusingly, that option is not used or
> needed when building for a PAPR guest (i.e. the "pseries" platform)
> but is used on non-IBM platforms using the "epapr" hypervisor
> interface.

... is_kvm_guest() returns false on !PSERIES now. Not intended
to break EPAPR. I'm not sure of a good way to share this between
EPAPR and PSERIES, I might just make a copy of it but I'll see.

Thanks,
Nick
