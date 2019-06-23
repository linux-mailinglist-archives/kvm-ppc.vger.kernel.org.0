Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D04FBF1
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 Jun 2019 15:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfFWNng (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 23 Jun 2019 09:43:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35152 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfFWNng (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 23 Jun 2019 09:43:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id p1so5387234plo.2
        for <kvm-ppc@vger.kernel.org>; Sun, 23 Jun 2019 06:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=/fW8MyFzuj7NpV0pnJQQTOZMS5efeSM18R6T3FiLtho=;
        b=CM1bPRz2X0i/naPm2VcpNyRTqjDfDmxGu1UfLZ7nLPlfLW8ZZyD403D52hvjT9QI0L
         ckMK9prCK6WVB2/ET+hn33RHeVjyumjRuLSjUNccvdHDoDQ+tfMf6qvX/KAalbJA+sFI
         VMCIvraINSQGn+DzYkXYzvPXt2AUiwNalJE2TO8l/Tz3kleDI69cXhGuorYl9Z9/1Bew
         x6QW1/1X6oIsqhGRu0Kqi6R+G1j5CbtBVIbRoBKYo166e8DL5nvvVljZnRdnSPHt9tbN
         lq5ZbrGljK3zG/tdCjiVUMBPsoZ3yDQ/U+xsrNVmRydqSz36XI8HLgJznPJWMg4Hvl0x
         AOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=/fW8MyFzuj7NpV0pnJQQTOZMS5efeSM18R6T3FiLtho=;
        b=glQ+S9NUBT8yVOwI1d9FCjv8+T4KSfak3PMzs/zgjUnen8OQqfJ6Htd30iZAnq1Zhc
         K5TfeZ3a11TMCL/MzcjnZ5mp+83vrePcOCnDPofsQt3pCCDF8xbU43nBoroJgs0CbSSw
         sgvvKoUsmfn+hx2tZkMnu2MKJ6IgNqZk+WmA4wbNtEHPEKs23bN1EEIKVUZdDuZ7xqhw
         0ad214wTe8aXOqpXz0ewEY+P8NEu0Hi8dij9iV1Z7j7BUBSqJCvvv4bHYaPT9H4u9g7Z
         Frr9D/quA/GqXSaD2bEVbSgB3VmN5p5n8GqB7FUhlS66xvVJJNYlwSkUGkGGOdIznrlF
         7hVQ==
X-Gm-Message-State: APjAAAWuVitDnrcf6q2c98LWln6wy3uevm6lsFY0AHOjEWcRWI1Hiiww
        JQO4pxYQVgDny8me6h6Of0MStDJy
X-Google-Smtp-Source: APXvYqxwBlq4iphRCZIKJytT6dxbOSH5x64lraSq1zOEZD9cvZ7O1/8tc/Wb4Clr4Nvi51PQZ/KLcw==
X-Received: by 2002:a17:902:4222:: with SMTP id g31mr65518531pld.41.1561297415803;
        Sun, 23 Jun 2019 06:43:35 -0700 (PDT)
Received: from localhost ([1.129.243.157])
        by smtp.gmail.com with ESMTPSA id 1sm8238503pfe.102.2019.06.23.06.43.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 06:43:34 -0700 (PDT)
Date:   Sun, 23 Jun 2019 23:42:59 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/2] powerpc/64s: Rename PPC_INVALIDATE_ERAT to
 PPC_ARCH_300_INVALIDATE_ERAT
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20190623104152.13173-1-npiggin@gmail.com>
        <20190623120332.GA7313@gate.crashing.org>
In-Reply-To: <20190623120332.GA7313@gate.crashing.org>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1561297021.pyb7y0yjt7.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Segher Boessenkool's on June 23, 2019 10:03 pm:
> On Sun, Jun 23, 2019 at 08:41:51PM +1000, Nicholas Piggin wrote:
>> This makes it clear to the caller that it can only be used on POWER9
>> and later CPUs.
>=20
>> -#define PPC_INVALIDATE_ERAT	PPC_SLBIA(7)
>> +#define PPC_ARCH_300_INVALIDATE_ERAT	PPC_SLBIA(7)
>=20
> The architecture version is 3.0 (or 3.0B), not "300".  This will work on
> implementations of later architecture versions as well, so maybe the name
> isn't so great anyway?

Yeah... this is kernel convention for better or worse. ISA v3.0B
feature support is called CPU_FTR_ARCH_300, and later architectures
will advertise that support. For the most part we can use architected
features (incompatible changes would require additional code).

Thanks,
Nick
=
