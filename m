Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E0C1D0728
	for <lists+kvm-ppc@lfdr.de>; Wed, 13 May 2020 08:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgEMGYa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 13 May 2020 02:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgEMGYa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 13 May 2020 02:24:30 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233C2C061A0E
        for <kvm-ppc@vger.kernel.org>; Tue, 12 May 2020 23:24:30 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 4so13314493qtb.4
        for <kvm-ppc@vger.kernel.org>; Tue, 12 May 2020 23:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ha/ounVPt6yY52Fm9rK6clkqfuhFQ2zd+ThkBQKemO4=;
        b=GLjuEFNsKrWt/eI0OIGIaj3JW23vEO6bqvgqwo2GFK/n+aEeWEAu86Hy+UzeD5t3xf
         G5jmATRNs1B79Y5CQo28cjOqzkn8Ark9FBUzQ+FBDKxL7JbGM57994g1ywYfgR0kS9F7
         ExQVOCPdnHWHrKhOQ5eJCPgNkpbadOmRSmyBvLQQYmfet/hNo9ZzL4yBs4HabnDaP8pa
         X3Wr4CFmML7GGpCr2C8jGf9Bu6hrkr4vTlUMnh7UrT1QoqmwUrYUBBrlGBGrR1qMU7uE
         hX0Slm0avY/QUfP4I838fUNVblnxc5ehhfMAKJYLpm42+ILRgPVPqhSsrwXOwvfi6fDq
         816g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=ha/ounVPt6yY52Fm9rK6clkqfuhFQ2zd+ThkBQKemO4=;
        b=kqbWOM/ktPKCdUGXN1ZemvYha79lMb4bpsHbrHZPeJbYRlp9E++qPRpVNbv3qfJcSO
         uXjqLCP1PnRfqw26brpgnZqJGYStPTuBAZCLm/kwIJMgHa3+usVg6jdp878JM5JKoSXx
         QTuET9FPg97INBCX0v9ypgRZaZeBZx3a5uO3kol9d+JpVkynd3UfO/f/Nn6VduLN8RNu
         X9TiDwlm5aqt6VXN0irsOFcyvDoLf8Lz7/y8cRSI+SaLx1jC56Z1E7q8oYktUQPGH1LS
         kFmXFCVMdqe7Hy8GnlWFFEL7I7u3JQjOUVunfWk2SSL7rOmF2HH8pxStw9QC9TKp9kSj
         QhEQ==
X-Gm-Message-State: AOAM533gMBlt1oxwUIZGn3ew6ZOQCdqB8wETPaLOkvZLzq1U2plq4dve
        hymGgbnq8fXIIFfy2vlK1N9zORuvlncZaw==
X-Google-Smtp-Source: ABdhPJxTYQm31Sf4DquSKEbLUABTbJHGdWBrkj7N/gWc05wPWn2ctXxedJf2IrAYckiob4si+X2FBQ==
X-Received: by 2002:ac8:724b:: with SMTP id l11mr6049058qtp.27.1589351069158;
        Tue, 12 May 2020 23:24:29 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id t12sm12580679qkt.77.2020.05.12.23.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 23:24:28 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] powerpc/kvm: silence kmemleak false positives
Date:   Wed, 13 May 2020 02:24:27 -0400
Message-Id: <F9DDFD57-C008-4518-B54C-91814286E2E8@lca.pw>
References: <87h7wkbhu4.fsf@mpe.ellerman.id.au>
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org,
        catalin.marinas@arm.com, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <87h7wkbhu4.fsf@mpe.ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



> On May 13, 2020, at 12:04 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:=

>=20
> This should probably also have an include of <linux/kmemleak.h> ?

No, asm/book3s/64/pgalloc.h has already had it and since this is book3s_64_m=
mu_radix.c, it will include it eventually from,

asm/pgalloc.h
  asm/book3s/pgalloc.h=
