Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E96533219
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 May 2022 22:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbiEXUCT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 May 2022 16:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241649AbiEXUCF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 May 2022 16:02:05 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927AB4AE1D
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 13:02:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v15so2983480pgk.11
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 13:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nSiT78fs0rHNFCm859cSTYy8LHahN2ayvynS0BLCkQo=;
        b=Ek+IULDg/rtui3HUMV+4eflNMofy5LIRYu59TPOuD04nwXw5H87sIFazc5+v9HExat
         Wto/jog+Te98IVhL978Uh264+Plg5w4xkUcHaXdbxTIbVnq8SNcoPCu6wk6rPm13Hjq+
         LuLitA653ZzKoAb9HLDLJ/V8FjKz39quQwhRg8c+rzRXwyKaWIf0jkQu+Xa4p85LuYlX
         jiCxMZnQ702PM7zJRHk6JA8riQkyGbJHw7lwG9rm/p69EKT47GlSa83nQqRRC3OSBIRG
         SEIYcqMNK+TWh+RzLsdLaxKX8zpxjRO2/yOik3vb4i7CAjE6o7ANby+XKKbQGYUAxoLf
         Wq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nSiT78fs0rHNFCm859cSTYy8LHahN2ayvynS0BLCkQo=;
        b=1dIhZr3C+5qLL9a0z1Mh22s6sOm5EkhFxBmt6n4Htc6OpaYeILgS5eGaCyrzQ3tWV/
         RO4oEo048lofxD3m5/itqAb+mx6trOBaYoC6XWUVTcbQkiKkKfWoTvEQHS9CZsJvhdlg
         CTkLDC/gcJHk3XZgZjvPD9X/MTP3e0VFJEUdRGZKB21tE9YbOlffZPdwtWeyLIRDRF2F
         gKfTDw3WKmF6KrltTvqh9gGJp8Ox4wRi1URMQh6zDyFmcFmqjAdOfPSwG68fh5LMCtdk
         BpjFi7pDWz9NHZ3MikAX7k7RjtslqRarQXw9S1hOk9/l//3sO2Ir3o/hENos//6Tcz+v
         GJ3w==
X-Gm-Message-State: AOAM532YFxihN3/i48GyD6EXeYV6e8Nmppz+Xok+jqwSNbg/ZSsgUiFt
        Cw/fldBz0eHgrlMSGOwsJ7VpbA==
X-Google-Smtp-Source: ABdhPJzC8/feTppnhxn35k8fZp8CY1rhtC7IgNahsC+W06ZS5CR1eDiLWUMYZnwc6bdaI1J4VLzBmQ==
X-Received: by 2002:a05:6a00:1890:b0:518:91bc:fbde with SMTP id x16-20020a056a00189000b0051891bcfbdemr14851214pfh.66.1653422522741;
        Tue, 24 May 2022 13:02:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g14-20020a056a001a0e00b0050dc76281bdsm9824579pfv.151.2022.05.24.13.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:02:02 -0700 (PDT)
Date:   Tue, 24 May 2022 20:01:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH kernel] KVM: Don't null dereference ops->destroy
Message-ID: <Yo05tuQZorCO/kc0@google.com>
References: <20220524055208.1269279-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524055208.1269279-1-aik@ozlabs.ru>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, May 24, 2022, Alexey Kardashevskiy wrote:
> There are 2 places calling kvm_device_ops::destroy():
> 1) when creating a KVM device failed;
> 2) when a VM is destroyed: kvm_destroy_devices() destroys all devices
> from &kvm->devices.
> 
> All 3 Book3s's interrupt controller KVM devices (XICS, XIVE, XIVE-native)
> do not define kvm_device_ops::destroy() and only define release() which
> is normally fine as device fds are closed before KVM gets to 2) but
> by then the &kvm->devices list is empty.
> 
> However Syzkaller manages to trigger 1).
> 
> This adds checks in 1) and 2).
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> I could define empty handlers for XICS/XIVE guys but
> kvm_ioctl_create_device() already checks for ops->init() so I guess
> kvm_device_ops are expected to not have certain handlers.

Oof.  IMO, ->destroy() should be mandatory in order to pair with ->create().
kvmppc_xive_create(), kvmppc_xics_create(), and kvmppc_core_destroy_vm() are doing
some truly funky stuff to avoid leaking the device that's allocate in ->create().
A nop/dummy ->destroy() would be a good place to further document those shenanigans.
There's a comment at the end of the ->release() hooks, but that's still not very
obvious.

The comment above kvmppc_xive_get_device() strongly suggests that keeping the
allocation is a hack to avoid having to audit all relevant code paths, i.e. isn't
done for performance reasons.
