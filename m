Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31569351316
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 12:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhDAKOj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 06:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhDAKO0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 06:14:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CDEC0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 03:14:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f17so806632plr.0
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 03:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=8EF/GMEyenok5uS/Yv0Ybl+raNvpq2SUPzPqjro+LzQ=;
        b=m0xaABoTry5jCute/N1uzG1YsoBY1sMOq0Q44lJnhpaGMUl7nPPjMHGyS5x9fnlV/X
         5JNkXV/RGo9Q0NQmqarIWOYhmyXqWUDJpYgSfwfE/MBNhd1lZoJXzEg5Fufu4t5r79H3
         T5VDd5xAiwRqE1YPNyBHAQlAMmef+/Cl0Up88NiVC6PvKvsYophKTb7MmKggdgh767t8
         VoT4wWGxoLP7JlnAEqnE6mjm2qnRV50PLBXh4pXKY3BO5XW9+BXFmc3M1/nRl5o/q5MO
         8UfQt9BVI4UuMGEvGSBjamx97VEZC5iVtzF8tbVLRKNG+rqUQR3/SxtgIQM/YnlIJ3/q
         Qu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=8EF/GMEyenok5uS/Yv0Ybl+raNvpq2SUPzPqjro+LzQ=;
        b=no30f9v7OJfr0U9g8inSn3lL71a3VAJVW3W2S9Id9nI2Pq+PWvVqC7/Fi7J9WYjDFn
         1kUIdFsKLDtYBfsloWxwOFAOMWYSQz5CODEFO7OeWui3AQQQyLNHm3U1srMz6qMHBaaZ
         YubwQUeGNKdH1YpeMkBIFQhi0R8WJw7pgHYCi2pGb7mnzWXW5tLOqxgEII2W2OhqB7zW
         qk22GI66sYZOlRV3bUeqk/rSCQ0eF2zgtQU2dVQRekvIzg+pZTFsmdqKuTOsp5eLicbS
         NWJ+m4BK4EVoTG5Uehv5ECl69bM7FRz00duOpDVHAK+FyOEUCDpwNwZiOrdvmqJFFECp
         sW4g==
X-Gm-Message-State: AOAM532m8CeEiEy1qjS+yGBA+DS/w2cKeVoOyNaZnm4K1GnkdkO40EJw
        Qh9kumIN33826atiOXkX2YW5sUn+1YGweQ==
X-Google-Smtp-Source: ABdhPJyaeWJ/xnKD7UuFJWBysx4pve2Xa3Fu5sHqWsQ54kxJfVx0e0QgcXmCQxg3wUpA2S2R7PjmYw==
X-Received: by 2002:a17:902:a513:b029:e5:d91c:2ede with SMTP id s19-20020a170902a513b02900e5d91c2edemr7176750plq.65.1617272065685;
        Thu, 01 Apr 2021 03:14:25 -0700 (PDT)
Received: from localhost ([1.128.222.237])
        by smtp.gmail.com with ESMTPSA id t17sm5428599pgk.25.2021.04.01.03.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 03:14:25 -0700 (PDT)
Date:   Thu, 01 Apr 2021 20:14:20 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 24/46] KVM: PPC: Book3S HV P9: Use large decrementer
 for HDEC
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-25-npiggin@gmail.com>
        <11ba0a43-a64a-ca06-581c-e8b7dc97b1d7@ozlabs.ru>
In-Reply-To: <11ba0a43-a64a-ca06-581c-e8b7dc97b1d7@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1617272048.6127blp34g.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of March 26, 2021 12:05 pm:
>=20
>=20
> On 23/03/2021 12:02, Nicholas Piggin wrote:
>> On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=
=3D0,
>> this could help reduce needless guest exits due to leftover exceptions o=
n
>> entering the guest.
>>=20
>> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
>=20
> ERROR: modpost: "decrementer_max" [arch/powerpc/kvm/kvm-hv.ko] undefined!
>=20
>=20
> need this:
>=20
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -89,6 +89,7 @@ static struct clocksource clocksource_timebase =3D {
>=20
>   #define DECREMENTER_DEFAULT_MAX 0x7FFFFFFF
>   u64 decrementer_max =3D DECREMENTER_DEFAULT_MAX;
> +EXPORT_SYMBOL_GPL(decrementer_max);

Added.

Thanks,
Nick
