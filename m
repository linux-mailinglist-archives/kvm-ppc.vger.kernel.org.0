Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECF556436F
	for <lists+kvm-ppc@lfdr.de>; Sun,  3 Jul 2022 02:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiGCAW6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 2 Jul 2022 20:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGCAW5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 2 Jul 2022 20:22:57 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF949B7EE
        for <kvm-ppc@vger.kernel.org>; Sat,  2 Jul 2022 17:22:56 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id v6so4451805qkh.2
        for <kvm-ppc@vger.kernel.org>; Sat, 02 Jul 2022 17:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pXQYTrkRp6SI4QLSxEaMkXFK+5MReQd/+YiGaX3jREY=;
        b=SCwP3aHJhWsq2AM8v6LjO2XbWfpEIf+3t5BkDAn5CmmW5jth2mXNFA0vjXWPXig+C9
         AHxehUGkgfHDMA/HLrO721PFQbv0p/EVZfkct2Vh3sqJpqREFLVA3dGGZyN9zjYXUNxE
         gdjW0H/leXTQuci8fAk0FPDr2t+QqG1WAph05nMsqi5LVpfHYJ2jvZJscyEP/S7XepLY
         jEjKtJzTKqH/+0mmZoerqCt0hvkmv7VbktZx1finQvO1M4LoMD8XdQMW6ct8EzLqQNxn
         xaX/D/B8y73oOvSk4RxaFRUyW4Sqt8BkwBX+hfRq2/J6eBx/wrVegkMrM9pbl6G+8Azh
         HhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pXQYTrkRp6SI4QLSxEaMkXFK+5MReQd/+YiGaX3jREY=;
        b=y6qpJnIpdE6tj8FL6R+EhMp3Tfxg6pogPNaQFNeqYv8ehRzm5AfmffBkQRPcjjO9Wc
         1JD9evi9JrFVfnrWxaVwUVDDylUtWsHayvTSUP/2/t0S74Ft/VBFriQWmy7HuvKC+aWE
         rlZPc2pZGIZTqbYw8JWSiVFEu+VNutvte86u9gJXztSuFGK6GdKxIhthccPN9CzkALpE
         fnDr3p1b8sT0r1KMVUNymSGp3H7ex2d+ekAtk8yp5lEfEzVV8CRZJt3pcDatO0/hwyQ7
         vgOk10X07SGuMTN+1UXtvtWF4idhxWENDonLEMO5UnSnMRbcrBg7ojV12IQQBBUAl1uZ
         zLDw==
X-Gm-Message-State: AJIora+Cbx2HxTx3S7tAtc8aRwe9hst6bjo0P0yps0DSbLZPqRyFc3T2
        pmCpNScyl4gwZIFuJsD2iaBoGQ==
X-Google-Smtp-Source: AGRyM1vmEh1Vw8AEVFlMuyZnqJrckn0YPw5G/UeJAdiGpLyeiP77PT28AE0c9JOTjXYKdvcOKOgVqA==
X-Received: by 2002:a37:a596:0:b0:6af:164a:d8ef with SMTP id o144-20020a37a596000000b006af164ad8efmr15387522qke.592.1656807775901;
        Sat, 02 Jul 2022 17:22:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id s9-20020ac85289000000b00304efba3d84sm17684789qtn.25.2022.07.02.17.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 17:22:54 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o7nO1-005DH6-R6; Sat, 02 Jul 2022 21:22:53 -0300
Date:   Sat, 2 Jul 2022 21:22:53 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
Subject: Re: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Message-ID: <20220703002253.GY23621@ziepe.ca>
References: <20220701061751.1955857-1-aik@ozlabs.ru>
 <31d6e625-b89d-c183-0b38-0ab8ec202e47@arm.com>
 <BN9PR11MB5276F1DF0264115CA8FCB3EA8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276F1DF0264115CA8FCB3EA8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 01, 2022 at 11:40:26PM +0000, Tian, Kevin wrote:

> But a bigger problem to me is how dma ownership is managed now on
> POWER. Previously it was guarded by BUG_ON and vfio_group_viable().

Yes. Simply removing or deferring this can't be good.

I think the solution is to not do iommu operations if there are no
iommu_ops, including allocating a blocking domain or trying to change
the domain - but continue to do all the refcounting/etc.

It is just another crufty work around for platforms that don't support
the iommu framework..

Jason
