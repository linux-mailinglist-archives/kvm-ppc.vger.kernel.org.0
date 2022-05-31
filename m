Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839F853954E
	for <lists+kvm-ppc@lfdr.de>; Tue, 31 May 2022 19:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346463AbiEaROE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 31 May 2022 13:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245056AbiEaROD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 31 May 2022 13:14:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9094E8DDF5
        for <kvm-ppc@vger.kernel.org>; Tue, 31 May 2022 10:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654017241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m7/4Jvl1GxfJCyijuYTPabJejXc5VFAL0WkoK632txQ=;
        b=MNpMsdn0imGHPKJFdmg3ypHVFRHT9wulFCqWnU+0hQd+tzWPdHVFapzJewqzrI0HFiy2yd
        3piNZabAkd1KlskDfuf1F1j/XtL9tDyP9h44V3X1Sq8fEtEo1Vxh69vsmOjn0tzaaneq0g
        gXh7dMYDnIrbjSaxHnlY1fZU549cNhI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-Q412GzEgNk-PWH9SQD5pSA-1; Tue, 31 May 2022 13:14:00 -0400
X-MC-Unique: Q412GzEgNk-PWH9SQD5pSA-1
Received: by mail-ej1-f69.google.com with SMTP id tl4-20020a170907c30400b006ff066327b2so5523820ejc.9
        for <kvm-ppc@vger.kernel.org>; Tue, 31 May 2022 10:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m7/4Jvl1GxfJCyijuYTPabJejXc5VFAL0WkoK632txQ=;
        b=IZPf1BLULyQHAFyodn/C9X3eyY4Ss53Fjptp3gr+vfs/XD4XCOTk61Qo60pfF4oyjl
         mTE8UmD2sVkzN/V2I6nzRoqgP6vDDF/2TlcnkhNBue2GJ38A0S2tvs1t+da1RHam3wAD
         ckcUbCBhnZlxpp7QSgc4rGwwOhredArwZe/329Xq5KPvg/YJ55DkboeAVinRy8Iw9lpr
         eJ+rnJL/rQiyx4fUOgZQ7Y8STE1Hlq/poWdPpMsw21m/kfweXfdehyjlgJVDvzUTLHV9
         FLKUuurhHJt7Z7XaJ7AMc5BEYRbRkZbY22q/Ig0gRJGAQJYZdAbNQjTLxuPpiKyvbs7b
         irpQ==
X-Gm-Message-State: AOAM532W9N0C/TztwYcE6/1e2rIXcTAXstFKvLeA/XCX8Dtp5UxYAEm2
        H0Yi3oAkybpbjz47iThkM3/Fpa6LFLn0+gnIxjpnDhqJpg9S0dtF60M4Btnwpe8AWsj4NLU51ok
        AUJWjVyjKhdKFdtDHdg==
X-Received: by 2002:a17:907:60cc:b0:6f4:ffba:489 with SMTP id hv12-20020a17090760cc00b006f4ffba0489mr55054961ejc.666.1654017238738;
        Tue, 31 May 2022 10:13:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxGzMUw98JD/e1wdexQWPZDJ+4PF4X/xC/mcuPhzcQzOIgh3sEKEe8MUzteOXa61j1eSXlbQ==
X-Received: by 2002:a17:907:60cc:b0:6f4:ffba:489 with SMTP id hv12-20020a17090760cc00b006f4ffba0489mr55054949ejc.666.1654017238544;
        Tue, 31 May 2022 10:13:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k10-20020a17090646ca00b006fed93bf71dsm5193576ejs.42.2022.05.31.10.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 10:13:57 -0700 (PDT)
Message-ID: <5b1b686e-d54c-014d-b93d-dc4b26a454c6@redhat.com>
Date:   Tue, 31 May 2022 19:13:56 +0200
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
 <4fdbe38d-0e7d-764f-beab-034a9f172137@redhat.com>
 <24c22c5c-2656-d590-2ae2-adfe0d3fd113@ozlabs.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <24c22c5c-2656-d590-2ae2-adfe0d3fd113@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 5/31/22 06:32, Alexey Kardashevskiy wrote:
>> -        ops->destroy(dev); 
>> +        if (ops->destroy)
>> +            ops->destroy(dev);
> 
> 
> btw why is destroy() not under the kvm->lock here? The comment in 
> kvm_destroy_devices() suggests that it is an exception there but not 
> necessarily here. Thanks,

The comment refers to walking the list.  The ops->destroy contract is 
that it's called outside kvm->lock, and that's followed in both places 
(both before and after the suggested patch).

Paolo

