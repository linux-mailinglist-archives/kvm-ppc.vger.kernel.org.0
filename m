Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323A45337AB
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 May 2022 09:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiEYHr1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 May 2022 03:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiEYHr0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 May 2022 03:47:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 663D160DB6
        for <kvm-ppc@vger.kernel.org>; Wed, 25 May 2022 00:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653464844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=weQ+tr4ZIW33xmlyie2lq7CER5QpGlbJKLBC5/fkDIo=;
        b=TE65l8+gUZ8LhQLqy8FCAVz6yb3bdfI1kTgpfVqc7/O+OgjxKZzjDO4U8aPiSgKSLWqGQW
        4wmgojfiqnZwLHUfS+yn2KE70/4gwFoqzk4fvqPYJEVN994hH+V6MsX7Ezl28ROOycEvPG
        my6npEboVAPeoxH7dTVkQ8OKi/szzAo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-S90CbGCHPFGSFNh3c8Bseg-1; Wed, 25 May 2022 03:47:22 -0400
X-MC-Unique: S90CbGCHPFGSFNh3c8Bseg-1
Received: by mail-ed1-f69.google.com with SMTP id j7-20020a056402238700b0042b9c2e9c64so1952607eda.19
        for <kvm-ppc@vger.kernel.org>; Wed, 25 May 2022 00:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=weQ+tr4ZIW33xmlyie2lq7CER5QpGlbJKLBC5/fkDIo=;
        b=djnpiyATYQnY+ZX2fNUqjdf8gfSHw7oHErapDYVJ8z+M3hnOjHoSu+64r3xp4OQ4VZ
         VkLZcyTSr0fNLODryVLnfzSKqxyzKO1KUHO4vgS6WCUHNYh4pWC3Eo7pT0Rh1iUV22j1
         W1LSRW7OchIKAMY8IWDG4ddHkYMoj4BM+2cXTxFVmw5wGSRUVIUolqgutTh2ppjOfKES
         AnF/ATAKqlJO3+N4g3V9woUz0jmSk1v4L12u8I73WN1cxh64g/FAIghJu0XGpbJve3Ai
         loVm8MDZMOWIXC/yB1qFDLWBQTzok+lcq+oqUtrewoDjo4TxCxjLzZXa5IQrr/3IU0UW
         +Vew==
X-Gm-Message-State: AOAM530ojWKuAuyMl0l/5dOwsPK73UV43mrFBSIO53CPcgxx6hYgZkdM
        lZBoJ64d/KzXXx4m6GDERk7u7GzWxogNP2YUQS8gyzekE/CA0gQIm6xdQKAs2gcUe8C+PwTVH1L
        nZWkCIPn24FKtMGDD1A==
X-Received: by 2002:a17:907:9626:b0:6fe:bae9:70bc with SMTP id gb38-20020a170907962600b006febae970bcmr18262773ejc.150.1653464841442;
        Wed, 25 May 2022 00:47:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjwVl+JlnNMeUnHXZpGc0oypUonMskZbMaAvtHu0B9VIKa+lK79/enkTX4OIesfF0BVtlNHA==
X-Received: by 2002:a17:907:9626:b0:6fe:bae9:70bc with SMTP id gb38-20020a170907962600b006febae970bcmr18262748ejc.150.1653464841153;
        Wed, 25 May 2022 00:47:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 8-20020a170906020800b006fe8b3d8cb6sm7533165ejd.62.2022.05.25.00.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 00:47:20 -0700 (PDT)
Message-ID: <4fdbe38d-0e7d-764f-beab-034a9f172137@redhat.com>
Date:   Wed, 25 May 2022 09:47:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH kernel] KVM: Don't null dereference ops->destroy
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
References: <20220524055208.1269279-1-aik@ozlabs.ru>
 <Yo05tuQZorCO/kc0@google.com>
 <cc19c541-0b5b-423e-4323-493fd8dafdd8@ozlabs.ru>
 <6d291eba-1055-51c3-f015-d029a434b2c0@ozlabs.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6d291eba-1055-51c3-f015-d029a434b2c0@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 5/25/22 04:58, Alexey Kardashevskiy wrote:
>>>
> 
> 
> After reading
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2bde9b3ec8bdf60788e9e 
> and neighboring commits, it sounds that each create() should be paired 
> with either destroy() or release() but not necessarily both.

I agree, if release() is implemented then destroy() will never be called 
(except in error situations).

kvm_destroy_devices() should not be touched, except to add a WARN_ON 
perhaps.

> So I'm really not sure dummy handlers is a good idea. Thanks,

But in that case shouldn't kvm_ioctl_create_device also try 
ops->release, i.e.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6d971fb1b08d..f265e2738d46 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4299,8 +4299,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
  		kvm_put_kvm_no_destroy(kvm);
  		mutex_lock(&kvm->lock);
  		list_del(&dev->vm_node);
+		if (ops->release)
+			ops->release(dev);
  		mutex_unlock(&kvm->lock);
-		ops->destroy(dev);
+		if (ops->destroy)
+			ops->destroy(dev);
  		return ret;
  	}

?

Paolo

