Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B15468834
	for <lists+kvm-ppc@lfdr.de>; Sun,  5 Dec 2021 00:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhLDXR4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 4 Dec 2021 18:17:56 -0500
Received: from mail-tycjpn01on2075.outbound.protection.outlook.com ([40.107.114.75]:19564
        "EHLO JPN01-TYC-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232658AbhLDXR4 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 4 Dec 2021 18:17:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAZ1LND8VLGFYz8qF+S8Lr06sbyF7KLNCQhCXdcf2siwR0l5+MYaNvEhrleesDNLNVoSF0N/eYEQ5lwvgV84A6Ah9+MVosgWKAZ0eeP5AKuWXoD9d23jporiYeOA7TcUvxDKxp+/qNqNGIe2lzoWRzzX0JXFtbduJ4T4+7ZLLbURCgiIo+BhKGa0+hDsEM41NYW9mOils0IFFYTy4JXr8I1Xb0YhFGX4RCSBw9PPNtc9KoQvBAobvK0qe176kEPsEgRFJDwopIW30k3pPyB0w5HptfyCdq4rj+LDFmdvivwRMaoGZlmcxcFgrM4h6LsSzQZsuiMhKzAg7a8QFBoGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOOW2IW38ajnNKLY9SWOWg4nL//vIOims8Ymtvy5YiE=;
 b=Pp0vD8qngbfh48+1/TQOdee8uBARWTtmf1rX6vTiHWwpkbnF8dfNCahJY61/4+ItwLYBnwjxCvVq+SwuWU35M77IbJVrDwCkz5snyyw7hybHRirxzojyKTa/I9QdDd/NQohyLz0Oyn+HDUlYmOyhoezXKS7r3PzRhNOfGz/CntyiqXH4X2gr+k2vIUaMbdJEwHYVO4Thm5HP50pQEh6FkxA7elCekvAjBss7AkDvCaiOamsqMC2Lm6G5WDZk8D7hTwtWot1BzL5xDo3yybMYQCaWsBuoAI69eMS+EX5S6zWWRXjLoihuHfMv/nXwrvbhFv5r6UnGQsbgBo4RV5xwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=asahitrading.com; dmarc=pass action=none
 header.from=asahitrading.com; dkim=pass header.d=asahitrading.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=asahitrading.onmicrosoft.com; s=selector2-asahitrading-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOOW2IW38ajnNKLY9SWOWg4nL//vIOims8Ymtvy5YiE=;
 b=MpNF7AOS9rqsxVwEfIM9DkScji2B7eUkygn7k3EtI/+b/+393ZnG9beo9IFKCHtxeywiHwgYd7w8WAnKY61pdYvSTfStxpXCnHU6aguzgSmhpw+fARUkKDxwS4S5SJZ+b/EzaigqoJp3sifiX3UAtQLqDCleOBoev9OwNkxc88A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=asahitrading.com;
Received: from OSZPR01MB6616.jpnprd01.prod.outlook.com (2603:1096:604:fe::7)
 by OSAPR01MB1905.jpnprd01.prod.outlook.com (2603:1096:603:15::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Sat, 4 Dec
 2021 23:14:28 +0000
Received: from OSZPR01MB6616.jpnprd01.prod.outlook.com
 ([fe80::d1c2:7fb6:4391:6d57]) by OSZPR01MB6616.jpnprd01.prod.outlook.com
 ([fe80::d1c2:7fb6:4391:6d57%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 23:14:28 +0000
Date:   Sat, 4 Dec 2021 23:14:27 +0000
To:     kvm-ppc@vger.kernel.org
From:   =?UTF-8?B?5pyd6Zm96LK/5piT5qCq5byP5Lya56S+?= 
        <liunan@asahitrading.com>
Reply-To: liunan@asahitrading.com
Subject: =?UTF-8?B?44GK5ZWP44GE5ZCI44KP44Gb44KS5Y+X44GR5LuY44GR44G+44GX44Gf?=
Message-ID: <vTAUktutV6rtnwezqxCfBincG5hcS30MunDray50XE@www.asahitrading.com>
X-Mailer: WPMailSMTP/Mailer/smtp 3.2.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYAPR01CA0071.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::35) To OSZPR01MB6616.jpnprd01.prod.outlook.com
 (2603:1096:604:fe::7)
MIME-Version: 1.0
Received: from www.asahitrading.com (157.7.44.199) by TYAPR01CA0071.jpnprd01.prod.outlook.com (2603:1096:404:2b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Sat, 4 Dec 2021 23:14:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01073510-9bce-49fa-9d99-08d9b77bd1f0
X-MS-TrafficTypeDiagnostic: OSAPR01MB1905:
X-Microsoft-Antispam-PRVS: <OSAPR01MB19053CA20837BCC5C512EB24B56B9@OSAPR01MB1905.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0uLJhbD5Ff+cDrDzeL2NHRqHxdxRLMG9lvycDtjh6h5kCssP61nvzz/M6r6qmfcxsLlHiYWJciMedDmyPpckSarLMap3y/z4VY7cnop/1rlPk+oSSA7Uw3I3Gxuz0XWqAV/Via0Hk44DRvK1YAPXhWFsmCBQpDrLuQMAsJxvFD4L45jeEdNu9vbRyMfXPxBPdNy2sZ3MQJT0bbCfskoDpBs+tNEfT9L0LgDrrcl+/QRYa/CkIrk67RkBPrT3547hzLPTiwwIb88muSdBl6bXCbfQPNG1EvBGLeTmtCSVlowt39axk1W97bynkEnNYbJQiox9qL60iG2TOzh5rILiXU66/gs+ubCEATml/wjkkmY4UhTXReyHsBXR1cc9jAeT4G+84K1lCmM6k+c9g3q0ZpolWWaDSw5SFVpEnIooYEjC4g+3F6brc5Hyu9CxThlK+llV2Fm3gksYp7opUMu0z8D/mLoS/PjyeKBxTvCPhzNDsRbizVnf+YB1dOwFtcqGNn8qRT7xZzw7mxB9g/nSMfQqULQ9uM5mEjRQiQ+rEnPvGhlsgaDEJRtnJGGf0um/t6086FtEudMQe2cMPeW5sc02wGri/2ffYovlLp+2vIGYPlaBjQ/wmUxR87aRkYlS/eSx2ymUlbiKhUZczDdhZ4oqhAO4OXOZfoEY0uoHYu1F6UyXK/ug68Hra0Lp98yBK4Rh8Mb4GAcCOLFg6E37OgtlMCH8IL4InbIjys39NwYTbvjKymc2UaBbd0kMiFcBChrKTQNQxb5/HqjPdRRjpoEBgdwhiLJTgAo2DqJdEFz3dQ1BM70t8t1UcPWJS3/88MUp0rqBcMv94f+0pad2N6JUXohppRAAYO1yFKNNlHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB6616.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39850400004)(136003)(376002)(366004)(85182001)(6916009)(3450700001)(55016003)(2906002)(66476007)(316002)(66556008)(66946007)(224303003)(558084003)(38100700002)(956004)(83380400001)(8936002)(86362001)(38350700002)(5660300002)(26005)(186003)(966005)(52116002)(7696005)(508600001)(47956004)(10090945008)(15302535012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXpiOTNzWkdVZ0VoOTN6UTdwWTBkRUwvdnEwL3FJdGpKL3lHam56MlF3cDdj?=
 =?utf-8?B?K0Fld0tCUnBTdkh2UmMxdkpyTExYQ05ReC8wZWllTDhsSjlCQUVsdThnSHFs?=
 =?utf-8?B?RjF4NHJIalQ2bEVMV2JtTGhQdW9ObXFRUWhYYnphYkxHeGVjRUZjS0pkcjRI?=
 =?utf-8?B?ZVRUaTcwVEFnS2dHQUdqSkRpU2p0ZWhacS94Z09hcXA5TlpLYWdzWE8yNnl1?=
 =?utf-8?B?UkZqZDJOTmZvTi9hMjNWUWN5bXYxSjZzdkFFNEJlZVFNSlNkWS9kNWlSZWNT?=
 =?utf-8?B?bi9qd2Z6S3hwY3cxVDlhNzV0cjM4cmdMNVduY0tkOXFsT2xXdTYyc3p5UlNH?=
 =?utf-8?B?NFdmc0Z3M0NvN2NqaHU3RVFIV2Y0ZHowSnRUQ2M2d3hnMm1xNWp1VEw0dmFQ?=
 =?utf-8?B?Q3Y2a1FURlpCRkpiZEtreXlxRVFFR3BTYW4zQTNsaTRSVTZubGVvTUNVMG1y?=
 =?utf-8?B?b0dXMWY5bFUycGZqbVJaRkJ0Z3BNRW1hYXh6Vnh0STVJY2Q1NEYzS2N5NFFz?=
 =?utf-8?B?VTVMQkxXS3ovRVJocjZuaUp3eXZ2T0phd1dCMXowL245SDBCa1N4MGtTTjVK?=
 =?utf-8?B?cWFOeWdjZVhSY01QeVVWZW9ERVFOcXgwM1NBRzcrQmhMT3BROVdXdjcwcnZr?=
 =?utf-8?B?MStoTEQ2Q2M4M28yeXFYbnBCZnBCY2R4WUtwQ2o3QURpU1JUaEJHMDV0emEr?=
 =?utf-8?B?YnlUeElUNEFIUkNUclRlcWtoRWxBd3VsOWFna0NjR3dpV2ZQWTJnUEwxTXYw?=
 =?utf-8?B?c2JVSjYwNVRFUGF4cEtOeGtaMUYxakRuQ056WW56ZERQbW9UQXJXVDMwQ1Qw?=
 =?utf-8?B?RERKcnNWM2JmdzBOV0o2c1Q2M01tdXhNOXNPZks2MktDelVCV2xlZmQ0UEZB?=
 =?utf-8?B?ejdsVjNJRTNEcjlVdEV4WC9sTlF1ZGFtWW1ONDh3anBPTU1rZDh6cC9kT0xS?=
 =?utf-8?B?MmJVOWhkS09jamJkT3FaT0d0aE1TQ0o0OEJlMytKTHlsSzkrWVdqWXdwSGZl?=
 =?utf-8?B?WEcrR2RqdWNJV3JIVFREWjNEM0FKZWpBMWZiZWFIY3FwVFdQUVIvSVQrMndu?=
 =?utf-8?B?OUpqQ0dONU5RaU9JMzZET3RMUG44cmJ2NWdkZVc3OThtMSs1bDg5UmxPaGtH?=
 =?utf-8?B?aTlELzVZVTkwVnd1dkJ3MUtuem1jbmpNTWNVcDA5OXhlZEFoMWJQRS9TWmFP?=
 =?utf-8?B?M2Nhbm5WTG5EUEdZVTRZWWRRNXloUTZxMHc1REhCU2VvU21qaG90aFNDTytG?=
 =?utf-8?B?M3ZLYlhEUllQWjgwenNZL2ovWDh1bEF1bFdjWDVlNE1VQkR6R0JhMkdJYXh6?=
 =?utf-8?B?S2dPODlrRVlVUkJYQ1RyVmRVdVdVaTRmV2dIeWJPREY1VWlJUGhFQ0VtRkNB?=
 =?utf-8?B?bXRWSnZHWjh0UVFqU1BvRkxybUFqRmFKR3lVNUFpZ3d1eWJRQW9SYndwNC94?=
 =?utf-8?B?ZkIxWkVmU0F5Ukg2ZW9JZjh5T0JsaTZycXJhSUVXL0pXcFQxV2t3YityaUFY?=
 =?utf-8?B?R1k1RGozODZFamJtcnlsT2l5eFNmOU9ZVGp5K0pENzdGQ20wRnk4RmdiQ0tN?=
 =?utf-8?B?TXl2ZVRlU0Fub050VndxQlIzRUFDVGxNR0s0SE4xRHBOWVUzRjJDUU96QWha?=
 =?utf-8?B?M2JiTWxRZi9vblNaZ3NsajdYRTBCMnpnS0RqWXpLMytPdjhFeEt6RThVbnRN?=
 =?utf-8?B?SGs2bTYrMzZ3NnVPd2F2V3dqU0N2SVlnenh3aEJiUjRGV2lkZnNSSjlnOFpt?=
 =?utf-8?B?T3lFMFRsU3F5NEEzbVpiSUZXd0hmZlNSNkFDZ2I0bS9jZWlldGl2TFFKc2l4?=
 =?utf-8?B?MkF0WDliQ3NJeTZvM3E4MmEyOG5uQVcwc0pJL0x6ZkJiMXV0OXVQdWROYS9V?=
 =?utf-8?B?NUxQQnlpQU90cnZ0dEEvbFJsM0pLazVyL0xkSjRvRWZnclNRQVFvMTdFdjFM?=
 =?utf-8?B?bVduZHl3c1g1cWlaVlpPTU5hR0pRbUNhaDF3L3hyUTlKd05TVlhqZmhvaVZK?=
 =?utf-8?B?S2hhZ2Q5bFY0dERBNTFjbUgxb1ZHM0o3bzZuM0FOeEF0eTBuNFZTTUpqN1R1?=
 =?utf-8?B?UTcyME5oVDcrSFdmV3dHaUw0YXdCQWVZTlludEprUjVWc2gwanYrb01jTXF0?=
 =?utf-8?B?MXM1R0dsRnB0SXhQQU1COWNxQ0dseDVLY3J5YjJrSGFOR1NXcFJyRUdxSk4y?=
 =?utf-8?Q?75PM2HsdeSo5E6WVVIRWy+c=3D?=
X-OriginatorOrg: asahitrading.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01073510-9bce-49fa-9d99-08d9b77bd1f0
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB6616.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 23:14:28.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ff30c363-a7e9-4e57-a326-29b897c5db18
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ra+qtgepnH5Ta3lhC9Qogy0ID8ZorpN7KKMgIRrteVq8q5IzfC8CTHaDoWHPVBaBEt/4KyF2fCpnnVXEu4fYXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1905
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

お問い合わせいただきまして、ありがとうございました。
こちらは自動返信の確認メールです。

社名：
❤️ You have unread messages from Alice (2)! Click Here: http://bit.do/fSMFV?t4fdu ❤️

部署：
4i4yec

お名前：
a067qn

住所：
kuwg75

電話番号：
007646220121-007646220121-007646220121

メールアドレス：
kvm-ppc@vger.kernel.org

お問い合わせ内容：
e1j2cex

