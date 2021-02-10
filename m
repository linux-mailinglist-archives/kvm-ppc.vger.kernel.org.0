Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6E8315D89
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Feb 2021 03:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhBJCwI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 21:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhBJCwG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 21:52:06 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF85C061574
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Feb 2021 18:51:25 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w18so320099pfu.9
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Feb 2021 18:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=U8jmIVnteY6Cvi+FunUg3/qgAhG73KICgddMeyHjELM=;
        b=lHQwf0E4G0LRXEJWL4K0euTXb73sLApH/1u4LImd3Q6fycxxgTm7p3ljKtEMNddT6P
         vKMLNBANySj3pT+rr4BAkCX5KldSoh0v4vbSDy/rzTYPN+24LYlFkpz5WXGv3Rf+/qWP
         WAkXX8PSwoRYOLXG956jD7iKIYfjccfOdLTPFDrESDdYiQz0kH57sFSIdg1kU0NLcbKC
         XV6+7FVPrzkBnG00wRGng6BFTSfJFnzBEOm6NXFeK/aUCH6ZIKcl0NcLPvcFl6xgxyO/
         RbkFNSmjXIhcLlVObzmyBL2lz9x4l7RrrElPeiCuV8MflywLBAyZwFDcD9d9PLb7sCn6
         d+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=U8jmIVnteY6Cvi+FunUg3/qgAhG73KICgddMeyHjELM=;
        b=gcJnIVgpZ9kwjKNqGVQQhay95J/AfJ7n6pp55LVTGtB6JKiqv59n5RFUjsau+fzgqP
         3W4h4lAiiaTDxVSJQ02gyMQBu2XzZSqX2DXPPD/wsfa2oRH8gu/6hDtc2GWWs+M6E2H6
         OSxumgJK0lAkPMbdwj40RUCQCRsdc0I3mKwrXSexGfMajEJ7kmdVoO1IM0Ty9+vKoK/P
         bt/EeCNzgKM1ToZATq4B59f1a6Y9ytwIeDQK3L7y8auzMhj+tOzuSpJBBuoas/MK65Ds
         zIIVG8Tig+T0mkbWch8OgUM3WUJ88aIQHCEzice83qhcPYoTsMmjS6yJKPjnfmfv8d9S
         ROSw==
X-Gm-Message-State: AOAM532bPxv9o58fzTcNb5iZ1lwN55ouuS68GIXR0gYCV8vyNCak0mMj
        WSASSPjmY9I4VbT3WvbUmN+g0dbVM5I=
X-Google-Smtp-Source: ABdhPJzGuyUf0+zPwFpXjibQ7Kru2qwEsnS+gmjOOBTPT99oWQMmTK0u/3Hj7NL5KcLAmIzhikOxuA==
X-Received: by 2002:a63:1f54:: with SMTP id q20mr1000253pgm.135.1612925484888;
        Tue, 09 Feb 2021 18:51:24 -0800 (PST)
Received: from localhost (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id w19sm279581pgf.23.2021.02.09.18.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 18:51:23 -0800 (PST)
Date:   Wed, 10 Feb 2021 12:51:17 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/4] KVM: PPC: Book3S HV: Fix radix guest SLB side channel
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210118062809.1430920-1-npiggin@gmail.com>
        <20210118062809.1430920-3-npiggin@gmail.com>
        <20210210012852.GD2854001@thinks.paulus.ozlabs.org>
In-Reply-To: <20210210012852.GD2854001@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1612925162.lmf4qdejxr.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of February 10, 2021 11:28 am:
> On Mon, Jan 18, 2021 at 04:28:07PM +1000, Nicholas Piggin wrote:
>> The slbmte instruction is legal in radix mode, including radix guest
>> mode. This means radix guests can load the SLB with arbitrary data.
>>=20
>> KVM host does not clear the SLB when exiting a guest if it was a
>> radix guest, which would allow a rogue radix guest to use the SLB as
>> a side channel to communicate with other guests.
>=20
> No, because the code currently clears the SLB when entering a radix
> guest,

Not AFAIKS.

> which you remove in the next patch.

The next patch avoids clearing host SLB entries when a hash guest is=20
entered from a radix host, it doesn't apply to radix guests. Not sure
where the changelog for it went but it should have "HPT guests" in the
title at least, I guess.

> I'm OK with moving the SLB
> clearing from guest entry to guest exit, I guess, but I don't see that
> you are in fact fixing anything by doing so.

I can set slb entries in a radix guest in simulator and observe they=20
stay around over host<->guest transitions, and they don't after this
patch.

Thanks,
Nick
