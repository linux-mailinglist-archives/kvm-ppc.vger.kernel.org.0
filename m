Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B0F482AAC
	for <lists+kvm-ppc@lfdr.de>; Sun,  2 Jan 2022 10:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiABJe4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 2 Jan 2022 04:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiABJe4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 2 Jan 2022 04:34:56 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDD1C061574
        for <kvm-ppc@vger.kernel.org>; Sun,  2 Jan 2022 01:34:55 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n10-20020a7bc5ca000000b00345c520d38eso16895067wmk.1
        for <kvm-ppc@vger.kernel.org>; Sun, 02 Jan 2022 01:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=g8Z10qgIS0EarfPNyU/0T6kl3UEk/EndXdl7judHSI4=;
        b=GFgUJdKnYsG7AUDyu/hhmXYSd1u3ICjiakxYyDK6fNiRsE+anWWcE6UB/2fc5fb6X+
         2fCBtgtiRWN1y9zPvoOt9hsPN03QTI+UOPkeAJx6n1CUhmxUKgQvV3WS5hXDLHl6txgC
         n2zSBTYrcGEqfLFYoSBAJx4k5sutbxgQRUBJ0nxBoGwbqqMRX0T9NrP2MopPzaiVy5Kr
         b9M4cD/MZSzIeUXyxzZL/5WUA8XMkYfEsjC6HURkRlICHB4pY+yS/D7ZAj1ezRsSLhx7
         n17TpV8Xc4mtjexkG5PLpzfXdR4aJcjLPUBP8U0utZhq7p77m5OXWkMguyhDiGKuNplJ
         iIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=g8Z10qgIS0EarfPNyU/0T6kl3UEk/EndXdl7judHSI4=;
        b=HU5XvS2B/Hdc1OUzbemM9crfO4fnbmkf7oK5kIJE/vXHvgUbz9HeaFsq4wLOJZ/4qe
         v5qU+BF01t8wyyLaXlZy2Ju+e7qgDnBApWWZzmR8RsrvqwfGkaK6PNbT5CSPd1l69NuZ
         KMjW0Yd6zDsNrArCqqly/Gp+sHlHKdcUZhT+Lj0ikbQMm2WbsYHXCr5Dq47MFW2HFWez
         YkGA7yO/YD8XssjdJXY8UQXGs0bCYHJWPUOAqX3CF+7bp2nqZVb4eGdC1216YUxCgjD3
         e00eMOUdtYxnpADfeG3cJa86D+lKxIQ3wcMdoOESjbzFpRzAVKaM8okA4ba/J2kPzOZg
         CFzw==
X-Gm-Message-State: AOAM531TMv/11JPmzpZE2s9WcoIWVCqPCMtVRW5V090Df+Sqo9/z6p+f
        OzWrbptJrpH5QysZt7moJS2Wte186okDaw==
X-Google-Smtp-Source: ABdhPJw39dGmRZ6AceJD73Q1wBUj387PFCe+MkTCZSrgDOdlvj8/zjyHop9Lp4uA0HM6oph+IjE95g==
X-Received: by 2002:a05:600c:3d0a:: with SMTP id bh10mr11508916wmb.70.1641116094315;
        Sun, 02 Jan 2022 01:34:54 -0800 (PST)
Received: from [192.168.9.102] ([197.211.59.105])
        by smtp.gmail.com with ESMTPSA id o9sm17643702wri.97.2022.01.02.01.34.50
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 02 Jan 2022 01:34:54 -0800 (PST)
Message-ID: <61d171be.1c69fb81.d98c1.75d7@mx.google.com>
From:   Margaret Leung KO May-yee <richmanjatau@gmail.com>
X-Google-Original-From: Margaret Leung KO May-yee
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?q?Gesch=C3=A4ftsvorschlag?=
To:     Recipients <Margaret@vger.kernel.org>
Date:   Sun, 02 Jan 2022 10:34:45 +0100
Reply-To: la67737777@gmail.com
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Am Mrs. Margaret Leung I have a business proposal for you reach at: la67737=
777@gmail.com

Margaret Leung
Managing Director of Chong Hing Bank
