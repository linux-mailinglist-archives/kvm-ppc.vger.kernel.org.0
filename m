Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FF41E34AC
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 May 2020 03:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgE0BWt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 26 May 2020 21:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgE0BWt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 26 May 2020 21:22:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0348C03E979
        for <kvm-ppc@vger.kernel.org>; Tue, 26 May 2020 18:22:48 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n11so17398246qkn.8
        for <kvm-ppc@vger.kernel.org>; Tue, 26 May 2020 18:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lfaYQxAvjEIlf4eTifAP04WQLIjbuEqWZK7YVJA2P8E=;
        b=bdCwamy6l5y36tWaBAzw2jsOMRDVBFifmX0OhKp5L2f5ScxkRWlrKyoQKiqD4EeJKV
         r+6FDToY923n0az0tXSPj3wsGp8copRiOZkLeDF23sQ+QpMMHNroqCBKC4N86cfu2+pE
         gRdAk3lFfu8cKsuCTWNl38G8C5Toaqo8iPC8JRJQTeT/TJD29zkYEdZWCjpGUaKsvExt
         Kgexof+updggUzQv3Hh5nwcCouAWGuH4y0cvBuPKaep20bdhYpSNeVaEiycuBhe/Q/cP
         WmDx9CVktclY7TJzbk7DtYAwo5yxGuvOGVb6xy40yatS8SOR2vr/6Vo0E0NQI1wRWObQ
         xn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lfaYQxAvjEIlf4eTifAP04WQLIjbuEqWZK7YVJA2P8E=;
        b=c7TyubW3XoQBzfMXAi+Nvf2Xj4rgiCWgIB+rYipptUEosfGdxy9XauQyv0zvxmnbdH
         avpzX3/JxbLlVrs7D42cnzBcrLttbAU9lxZc2ZQ93PzX7aZzLEnjKmAqJg0nQ18BsfNQ
         EqRP637EYrMHgdsYMLgj7nJneqt9F4udD1ZrqzfClD42Phybrwbi/83vVsNEMrXq2oBQ
         pVGUOEVcBA/pmm7pGv5a9xeppwDnkEIgkzee4dtm/SratV2KUyeiFgXG9jqCVTrNn1dY
         8WwhzwnNvYNCBW5ZyhqVmwEuPmaW7tRVzR/RJaU/UXSdAt2OIde7309lpDn8D2DLZyA5
         FBBA==
X-Gm-Message-State: AOAM533Rtvd699ahXI68KN1WkLL7CB50dWlkw5NMdxZOK6y3noS0c3P1
        obnASBpgAs5nVg4I2qJ8EdUyEw==
X-Google-Smtp-Source: ABdhPJwVgOsRZKK7L4GJOZmoCuR0CuYBMeqWZSLSs2+BbpvtTBspMPRVLYX3X/faUhr8Z3IcSE8AVw==
X-Received: by 2002:a37:9586:: with SMTP id x128mr1790368qkd.312.1590542568200;
        Tue, 26 May 2020 18:22:48 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id x41sm1286992qtb.76.2020.05.26.18.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 18:22:47 -0700 (PDT)
Date:   Tue, 26 May 2020 21:22:45 -0400
From:   Qian Cai <cai@lca.pw>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, aik@ozlabs.ru,
        paulmck@kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/kvm/book3s64/vio: fix some RCU-list locks
Message-ID: <20200527012245.GJ991@lca.pw>
References: <20200510051834.2011-1-cai@lca.pw>
 <20200527011323.GA293451@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527011323.GA293451@thinks.paulus.ozlabs.org>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, May 27, 2020 at 11:13:23AM +1000, Paul Mackerras wrote:
> On Sun, May 10, 2020 at 01:18:34AM -0400, Qian Cai wrote:
> > It is unsafe to traverse kvm->arch.spapr_tce_tables and
> > stt->iommu_tables without the RCU read lock held. Also, add
> > cond_resched_rcu() in places with the RCU read lock held that could take
> > a while to finish.
> 
> This mostly looks fine.  The cond_resched_rcu() in kvmppc_tce_validate
> doesn't seem necessary (the list would rarely have more than a few
> dozen entries) and could be a performance problem given that TCE
> validation is a hot-path.
> 
> Are you OK with me modifying the patch to take out that
> cond_resched_rcu(), or is there some reason why it's essential that it
> be there?

Feel free to take out that cond_resched_rcu(). Your reasoning makes
sense.
