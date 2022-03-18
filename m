Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E2A4DDABC
	for <lists+kvm-ppc@lfdr.de>; Fri, 18 Mar 2022 14:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236759AbiCRNnT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 18 Mar 2022 09:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiCRNnS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 18 Mar 2022 09:43:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D9E02DCBDD
        for <kvm-ppc@vger.kernel.org>; Fri, 18 Mar 2022 06:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647610914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DIbniuNolZexjaWhREmeAy3eBGSMYEukIAiBx0oi6HQ=;
        b=hFqm94/Q2wN0+NnYZyhE0BcwhNDsThb0w64W3d60AkPeiPgLvaoLUFMIfHFvEwqwBioGHH
        4OJ2OUCY8Kzpet9SCh5xkAeyppLRM7Q0Ey+xdDAAXhhdPotd7tfyy39qagVn1S4/Rh48L8
        tbs2BuZ3SoH1UsxiVczX11VKCwP48dw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-56haqiCaO4eQNEHsyAMi-A-1; Fri, 18 Mar 2022 09:41:53 -0400
X-MC-Unique: 56haqiCaO4eQNEHsyAMi-A-1
Received: by mail-ed1-f70.google.com with SMTP id w8-20020a50d788000000b00418e6810364so4873485edi.13
        for <kvm-ppc@vger.kernel.org>; Fri, 18 Mar 2022 06:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DIbniuNolZexjaWhREmeAy3eBGSMYEukIAiBx0oi6HQ=;
        b=pukXJgOrpkJgcWViHV8sTLr1uAJv33MWXbjwBVOVUyBGx0xqDTpgtQlzOq9RUSmjR4
         Qxw9ekgIyQgbPHREFSDw+Z5px+MSkecP3srjsn0pZnvpZgeuoHw7uh+iARrYcK8RlM4i
         YXKxD5S9iE+cneb0bWU50aT1EaDS5aOHrmzr25w6vbv8a8vXIV53KuOAMM+PbPXgfVKe
         y7dg8jsQ2FFLpr6fi9Na7CkzOaiAfvPYA97Lxp3wSl1cI0+87aWSJ2AGyyNvpW5xSyGy
         MmyPqKjBb5AKro8i7QXt0gOfIg9tieXboKxCiQIJyDUWySQamMWhlnH5NBrbU5Ksnrik
         adHg==
X-Gm-Message-State: AOAM531wjzRl6I9WfmgA/MDe6sNlIY7Tu63BD9gxdUtlBA9+5A/bc0er
        4eA4Li7wouvPAOrBuJKfVM4EBSJSYnVSN/qZIbCNPLB3ypMd1ypXAxoMZPcEeFMl5Ds9UOOfGp0
        vD7o76+hQHrpkHsItlQ==
X-Received: by 2002:a17:906:1742:b0:6d6:c4f5:84a2 with SMTP id d2-20020a170906174200b006d6c4f584a2mr8868772eje.25.1647610912648;
        Fri, 18 Mar 2022 06:41:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/BdGNh9JsyvjgFzL96Y9Vz6rTgp8OmTHioc8M6Nr9yVk3fxjLP8PWfjOZehG7pgTumaNf0Q==
X-Received: by 2002:a17:906:1742:b0:6d6:c4f5:84a2 with SMTP id d2-20020a170906174200b006d6c4f584a2mr8868744eje.25.1647610912407;
        Fri, 18 Mar 2022 06:41:52 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id i3-20020a1709067a4300b006dd879b4680sm3812678ejo.112.2022.03.18.06.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:41:52 -0700 (PDT)
Date:   Fri, 18 Mar 2022 14:41:49 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, alexandru.elisei@arm.com,
        thuth@redhat.com, suzuki.poulose@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
Message-ID: <20220318134149.i2dqdaiwk3twbixn@gator>
References: <20220316060214.2200695-1-morbo@google.com>
 <20220318093601.zqhuzrp2ujgswsiw@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318093601.zqhuzrp2ujgswsiw@gator>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 18, 2022 at 10:36:01AM +0100, Andrew Jones wrote:
> On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
> > Clang warns about using a bitwise '|' with boolean operands. This seems
> > to be due to a small typo.
> > 
> >   lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >           if (can_assume(LIBFDT_ORDER) |
> > 
> > Using '||' removes this warnings.
> > 
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  lib/libfdt/fdt_rw.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
> > index 13854253ff86..3320e5559cac 100644
> > --- a/lib/libfdt/fdt_rw.c
> > +++ b/lib/libfdt/fdt_rw.c
> > @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
> >  			return struct_size;
> >  	}
> >  
> > -	if (can_assume(LIBFDT_ORDER) |
> > +	if (can_assume(LIBFDT_ORDER) ||
> >  	    !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
> >  		/* no further work necessary */
> >  		err = fdt_move(fdt, buf, bufsize);
> > -- 
> > 2.35.1.723.g4982287a31-goog
> >
> 
> We're not getting as much interest in the submodule discussion as I hoped.
> I see one vote against on this thread and one vote for on a different
> thread[1]. For now I'll just commit a big rebase patch for libfdt. We can
> revisit it again after we decide what to do for QCBOR.
>

Now merged through misc/queue.

Thanks,
drew 

